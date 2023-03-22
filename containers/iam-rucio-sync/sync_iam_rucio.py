import os
import requests
import warnings
import logging
import json
import argparse
from configparser import ConfigParser
from rucio.common.types import InternalAccount
from rucio.core import identity, account, rse
from rucio.db.sqla.constants import IdentityType
from rucio.db.sqla.constants import AccountType
from rucio.core.account_limit import set_local_account_limit
from rucio.core.account import add_account_attribute
from sqlalchemy import exc as sa_exc

logging.basicConfig(level=logging.DEBUG)

CONFIG_PATH = "./iam-sync.conf"


class IAM_RUCIO_SYNC():

    TOKEN_URL = "/token"
    GET_USERS_URL = "/scim/Users"

    def __init__(self, config_path):
        self.config_path = config_path
        self.configure()

    def configure(self):
        self.iam_server = None
        self.client_id = None
        self.client_secret = None
        self.token_server = None

        config = ConfigParser()
        files_read = config.read(self.config_path)
        if len(files_read) > 0:
            self.iam_server = config.get('IAM', 'iam-server')
            self.client_id = config.get('IAM', 'client-id')

            if config.has_option('IAM', 'client-secret'):
                self.client_secret = config.get('IAM', 'client-secret')
            else:
                client_secret_path = config.get('IAM', 'client-secret-path')
                with open(client_secret_path, 'r') as client_secret_file:
                    self.client_secret = client_secret_file.read().rstrip()

            if config.has_option('IAM', 'token-server'):
                self.token_server = config.get('IAM', 'token-server')
            else:
                self.token_server = self.iam_server

        # Overwrite config with ENV variables
        self.iam_server = os.getenv('IAM_SERVER', self.iam_server)
        self.client_id = os.getenv('IAM_CLIENT_ID', self.client_id)
        self.client_secret = os.getenv('IAM_CLIENT_SECRET', self.client_secret)
        self.token_server = os.getenv('IAM_TOKEN_SERVER', self.token_server)
        if self.token_server is None:
            self.token_server = self.iam_server

        # Validate all required settings are set or throw exception
        # TODO

    def get_token(self):
        """
        Authenticates with the iam server and returns the access token.
        """
        request_data = {
            "client_id": self.client_id,
            "client_secret": self.client_secret,
            "grant_type": "client_credentials",
            "username": "not_needed",
            "password": "not_needed",
            "scope": "scim:read"
        }
        r = requests.post(self.token_server + self.TOKEN_URL, data=request_data)
        response = json.loads(r.text)

        if 'access_token' not in response:
            raise RuntimeError("Authentication Failed")

        return response['access_token']

    def get_list_of_users(self, access_token):
        """
        Queries the server for all users belonging to the VO.
        """

        startIndex = 1
        count = 100
        header = {"Authorization": "Bearer %s" % access_token}

        iam_users = []
        users_so_far = 0

        while True:
            params_d = {"startIndex": startIndex, "count": count}
            response = requests.get("%s/scim/Users" % self.iam_server,
                                    headers=header,
                                    params=params_d)
            response = json.loads(response.text)

            iam_users += response['Resources']
            users_so_far += response['itemsPerPage']

            if users_so_far < response['totalResults']:
                startIndex += count
            else:
                break

        # TODO: Handle exceptions, error codes
        return iam_users

    def sync_accounts(self, iam_users):

        for user in iam_users:

            username = user['userName']
            email = user['emails'][0]['value']

            if not user['active']:
                logging.debug(
                    'Skipped account creation for User {} [not active]'.format(
                        username))
                continue

            # Rucio DB schema restriction
            if len(username) > 25:
                logging.debug(
                    'Skipped account creation for User {} [len(username) > 25]'.
                    format(username))
                continue

            if not account.account_exists(InternalAccount(username)):
                account.add_account(InternalAccount(username),
                                    AccountType.SERVICE, email)
                logging.debug(
                    'Created account for User {} ***'.format(username))

                # Give account quota for all RSEs
                for rse_obj in rse.list_rses():
                    set_local_account_limit(InternalAccount(username),
                                            rse_obj['id'], 1000000000000)

                # Make the user an admin & able to sign URLs
                try:
                    add_account_attribute(InternalAccount(username), 'admin',
                                          'True')
                    add_account_attribute(InternalAccount(username), 'sign-gcs',
                                          'True')
                except Exception as e:
                    logging.debug(e)

            if "groups" in user:
                for group in user['groups']:
                    group_name = group['display']
                    if not account.has_account_attribute(
                            InternalAccount(username), group_name):
                        add_account_attribute(InternalAccount(username),
                                              group_name, 'True')

    def sync_oidc(self, iam_users):

        for user in iam_users:

            username = user['userName']
            email = user['emails'][0]['value']
            user_subject = user['id']

            if not user['active']:
                logging.debug(
                    'Skipped OIDC identity for User {} [not active]'.format(
                        username))
                continue

            # Rucio DB schema restriction
            if len(username) > 25:
                logging.debug(
                    'Skipped OIDC identity for User {} [len(username) > 25]'.
                    format(username))
                continue

            try:
                internal_account = InternalAccount(username)
                user_identity = "SUB={}, ISS={}".format(user_subject,
                                                        self.iam_server)

                if not identity.exist_identity_account(
                        user_identity, IdentityType.OIDC, internal_account):
                    identity.add_account_identity(user_identity,
                                                  IdentityType.OIDC,
                                                  internal_account, email)
                    logging.debug(
                        'Added OIDC identity for User {}'.format(username))
            except Exception as e:
                logging.debug(e)

    def sync_x509(self, iam_users):

        for user in iam_users:

            username = user['userName']
            email = user['emails'][0]['value']

            if not user['active']:
                logging.debug(
                    'Skipped X509 identity for User {} [not active]'.format(
                        username))
                continue

            # Rucio DB schema restriction
            if len(username) > 25:
                logging.debug(
                    'Skipped X509 identity for User {} [len(username) > 25]'.
                    format(username))
                continue

            if 'urn:indigo-dc:scim:schemas:IndigoUser' in user:
                indigo_user = user['urn:indigo-dc:scim:schemas:IndigoUser']
                if 'certificates' in indigo_user:
                    for certificate in indigo_user['certificates']:
                        if 'subjectDn' in certificate:
                            subjectDn = self.make_gridmap_compatible(
                                certificate['subjectDn'])

                            try:
                                internal_account = InternalAccount(username)

                                if not identity.exist_identity_account(
                                        subjectDn, IdentityType.X509,
                                        internal_account):
                                    identity.add_account_identity(
                                        subjectDn, IdentityType.X509,
                                        internal_account, email)
                                    logging.debug(
                                        'Added X509 identity for User {}'.
                                        format(username))

                            except Exception as e:
                                logging.debug(e)

    def make_gridmap_compatible(self, certificate):
        """
        Take a certificate and make it compatible with the gridmap format.
        Basically reverse it and replace ',' with '/'
        """
        certificate = certificate.split(',')
        certificate.reverse()
        certificate = '/'.join(certificate)
        certificate = '/' + certificate
        return certificate


if __name__ == '__main__':

    parser = argparse.ArgumentParser()

    parser.add_argument("--debug",
                        required=False,
                        dest="debug",
                        action='store_true',
                        help="Toggle debug mode and export file with user list.")
    parser.set_defaults(debug=False)

    arg = parser.parse_args()
    debug = arg.debug

    with warnings.catch_warnings():
        warnings.simplefilter("ignore", category=sa_exc.SAWarning)

        logging.info("Starting IAM -> RUCIO synchronization.")

        # configure IAM syncer
        syncer = IAM_RUCIO_SYNC(CONFIG_PATH)

        # get SCIM access token
        access_token = syncer.get_token()

        # get all users from IAM
        iam_users = syncer.get_list_of_users(access_token)

        # DEBUG user output to file
        if debug:
            with open("list_of_users.json", "w") as outfile:
                json.dump(iam_users, outfile, indent=4)

        # sync accounts
        syncer.sync_accounts(iam_users)

        # sync OIDC identities
        syncer.sync_oidc(iam_users)

        # sync X509 identities
        syncer.sync_x509(iam_users)

        logging.info("IAM -> RUCIO synchronization successfully completed.")
