## Adding IAM users to Reana DB 

This container inherits from the `reana-server` container to run DB operations. 
At the moment, the users subscribe to IAM and get automatic access to Rucio. They can also get access to the [reana-vre.cern.ch](reana-vre.cern.ch) instance, but once inside they need to request a token, and their request needs to be approved by us after we receive an email notification. This scripts automatises the process of the IAM users getting a Reana token, to lighten the work of the administrators. 
The list of IAM users is updated every day, new users are added and a Reana token is granted to them.  

The python scripts:
-  `generate_email_list.py` fetches the email list of all IAM subscribed users and gets a `emails.json` list of all of them. Notice the `StartIndex` trick to get all of the emails, as usually the IAM server only returns the first 100 results. 
- `add_reana_users.py` reads the email list and executes a `reana-admin` command to add the users to the Reana DB, and assigns a "Reana token" to them. This token has infinite lifetime, so it is more of a password. The Reana team is working on the implementation of an OAuth authentication implementation, after which the current container and functionality will become obsolete. 