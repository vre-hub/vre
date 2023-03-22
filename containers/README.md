## Automatised build of VRE operations containers 

The repository contains the Docker containers used to maintain the VRE cluster updated, up and running. Each folder contains a Dockerfile that builds an image. The automation of the build process is described in the /workflows repository, and is triggered for each image every time a commit to the `main` branch happens within the repo specific to the image. 

The containers are:

1. `rucio-client`: to run on your local laptop, has all the packages installed to authenticate with the VRE Rucio instance, to upload, replicate and download data. 
2. `iam-rucio-sync`: syncronisation script to keep the `accounts` table of the Rucio DB updated every time a new user registers with the IAM ESCAPE identity provider. 
3. `rucio-noise`: dummy files upload and deletion for monitoring through a client. 

## Version change

Change the `requirements.txt` and/or the Dockerfile's `BASETAG` arg in each repo to update to the latest/desired software version. If it is not present, change the version directly in the docker image. 