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

### Using environment variables

```bash
$ docker run --user root -e RUCIO_CFG_ACCOUNT=<myrucioaccount> -v ~/.globus/usercert.pem:/opt/rucio/etc/client.crt -v ~/.globus/userkey.pem:/opt/rucio/etc/client.key -it --name=rucio-client ghcr.io/vre-hub/vre-rucio-client
```

### Using environment variables and a X.509 proxy

```bash
$ voms-proxy-init
$ docker run -e RUCIO_CFG_ACCOUNT=<myrucioaccount> -e RUCIO_CFG_AUTH_TYPE=x509_proxy -e RUCIO_CFG_CLIENT_X509_PROXY=/opt/proxy/x509up_uNNNN -v /tmp:/opt/proxy -it --name=rucio-client rucio-client
```

### Using a bespoke rucio.cfg

```bash 
$ docker run -e RUCIO_CFG_ACCOUNT=<myrucioaccount> -v /path/to/rucio.cfg:/opt/rucio/etc/rucio.cfg -v /path/to/client.crt:/opt/rucio/etc/client.crt -v /path/to/client.key:/opt/rucio/etc/client.key -it --name=rucio-client ghcr.io/vre-hub/vre-rucio-client
```

## Run with userpass authentication

```bash
$ docker run -e RUCIO_CFG_ACCOUNT=<myrucioaccount> -e RUCIO_CFG_AUTH_TYPE=userpass -e RUCIO_CFG_USERNAME=<myrucioname> -e RUCIO_CFG_PASSWORD=<myruciopassword> -it --name=rucio-client ghcr.io/vre-hub/vre-rucio-client
```
