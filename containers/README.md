# Automatised build of VRE operations containers 

This directory builds the Docker images used to maintain the VRE cluster updated, up and running. Each folder contains a `Dockerfile`, plus the operations scripts needed to run each container as cronjobs in the VRE cluster. 
The building of the images is described in the `.github/workflows` directory. 

Each image is triggered every time a new release is made, or a change is made to the any of scripts that are included in the image that will run as a conjob in the cluster. 

Most of the images are built on top of a common base image that contains the common software needed for all `VRE` ops. This image is named `vre-base-ops` and starts from a fixed `rucio/rucio-server` stable version - to date (Jun '23), this version is `release-1.30.0`.

The images are that can be found in this directory:

1. `rucio-client`: to run on your local laptop, has all the packages installed to authenticate with the VRE Rucio instance, to upload, replicate and download data. It also contains the latest `REANA` client. This image starts from `rucio/rucio-clients:release-1.30.0`, though.
2. `rucio-noise`: interacts with the `VRE` monitoring instance uploading, deleating and creating replication rules to test the status of the cluster. 
3. `iam-rucio-sync`: image that runs asyncronisation script to keep the `accounts` table of the `Rucio` DB updated every time a new user registers with the `IAM ESCAPE` identity provider. 
4. `iam-reana-sync`: adds any new user registered to the `IAM ESCAPE` to the `REANA` DB and grants access to the `VRE-REANA` instance.


## Version change

Change the `Dockerfile` or any script within the different container sub-folders.

 - Any change on the `base-ops` image **must** be followed by a minor tag/release (`vX.Y.(Z+1)`). 
    - This will trigger a two step workflow in where first the `base-ops` container will be built, then the rest of containers.
    - All containers will be then tagged with `vX.Y.(Z+1)`.
 - On any other situation, any changes within the `Dockerfile` or the operations scripts of the corresponding subfolder, will trigger the build of the corresponding container.
    - In this case, the container will be tagged as `vX.Y.Z-<git_distance>-<short-sha>`.
