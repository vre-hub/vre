import requests, json, os

client_id = os.environ["CLIENT_ID"]
client_secret = os.environ["CLIENT_SECRET"]

token_resp = requests.post(
    "https://iam-escape.cloud.cnaf.infn.it/token",
    data={
        "grant_type": "client_credentials",
        "client_id": client_id,
        "client_secret": client_secret,
        "scope": "scim:read",
    },
    headers={"Content-Type": "application/x-www-form-urlencoded"},
)

token = token_resp.json()["access_token"]
headers = {"Authorization": "Bearer %s" % token}
list_url = "https://iam-escape.cloud.cnaf.infn.it/scim/Users"

startIndex = 1
results = []
resp = requests.get(list_url, headers=headers, params={"startIndex": startIndex})
resp_json = resp.json()
response = json.loads(resp.text)

# need to do this as IAM returns only first 100 results

while startIndex < response["totalResults"]:
    resp = requests.get(list_url, headers=headers, params={"startIndex": startIndex})
    resp_json = resp.json()
    response = json.loads(resp.text)
    for user in resp_json["Resources"]:
        for email in user["emails"]:
            results.append(email["value"])
            print(email["value"])
        startIndex += 1
    print(startIndex)

with open("/home/emails.json", "w+") as fp:
    fp.write(json.dumps(results))
