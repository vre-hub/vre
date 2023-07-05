# VRE rucio-client container

This directory contains the Dockerfile for the Rucio client enabled for the [ESCAPE](https://projectescape.eu/) VO, used to authenticate users to the VRE.

Please refer to the official [Rucio  clients repo](https://github.com/rucio/containers/tree/master/clients) for more information.  

The Docker image for this project can be pulled with:

```console
$ docker pull ghcr.io/vre-hub/vre-rucio-client:latest
```

## Rucio-clients version change

This container depends on the `rucio/rucio-client:release-1.30.0`. Change any file within the folder or the Dockerfile's `BASETAG` tag. 

## Run with X.509 authentication

Have your certificate ready and divided into two files named ~/.globus/userkey.pem and ~/.globus/usercert.pem, as descibed in the [VRE documentation](https://vre-hub.github.io/docs/auth.html).

```bash
docker run --user root -e RUCIO_CFG_CLIENT_X509_PROXY=/tmp/x509up -e RUCIO_CFG_AUTH_TYPE=x509_proxy -e RUCIO_CFG_ACCOUNT=<myrucioname> -v ~/.globus/usercert.pem:/opt/rucio/etc/client.crt -v /.globus/userkey.pem:/opt/rucio/etc/client.key -it --name=rucio-client ghcr.io/vre-hub/vre-rucio-client
```

Once you are inside, generate the proxy:

```
$ voms-proxy-init --voms escape --cert /opt/rucio/etc/client.crt --key /opt/rucio/etc/client.key --out /tmp/x509up --debug
```
Then you can perform all rucio actions, like running `rucio whoami` to check you are authenticated against the server. 

## Run with token authentication
You only need to run the container specifying that you want to be authenticated with tokens. You will need to click on a link that authenticates you against the server and you are set to go. 

```
docker run --user root -e RUCIO_CFG_AUTH_TYPE=oidc -e RUCIO_CFG_ACCOUNT=<myrucioname> -it --name=rucio-client ghcr.io/vre-hub/vre-rucio-client
```
## Run with userpass authentication

```bash
$ docker run -e RUCIO_CFG_ACCOUNT=<myrucioaccount> -e RUCIO_CFG_AUTH_TYPE=userpass -e RUCIO_CFG_USERNAME=<myrucioname> -e RUCIO_CFG_PASSWORD=<myruciopassword> -it --name=rucio-client ghcr.io/vre-hub/vre-rucio-client
```
