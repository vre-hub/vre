## Adding IAM users to Reana DB 

This container inherits from the `reana-server` container to run DB operations. 
At the moment, the users subscribe to IAM and get automatic access to Rucio. They can also get access to the [reana-vre.cern.ch](reana-vre.cern.ch) instance, but once inside they need to request a token, and their request needs to be approved by us after we receive an email notification. This is annoying, as with the IAM account they should automatically be able to use the VRE REANA cluster. This script therefore updates the email IAM list every day, to see if there are new users, and grants them a Reana token already, so they do not have to wait for us to grant them access to the instance. 

The python scripts:
-  `generate_email_list.py` fetches the email list of all IAM subscribed users and gets a .json list of all of them. In order to poll the IAM service to get all results, a workaround is needed as usually the basic script would only return the first 100 results. 
- `add_reana_users.py` reads the email list and executes a flask command to add the users to the Reana DB, and assigns a token to them. This token has infinite lifetime, so it is not the most secure solution. The Reana team is working on the implementation of an OAuth identification, after which this cotnainer and functionality will become obsolete. 