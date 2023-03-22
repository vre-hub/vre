## Automatised build of the rucio-client container

This repository contains the Dockerfile for the Rucio client enabled for the [ESCAPE](https://projectescape.eu/) VO, used to authenticate users to the VRE.

Please refer to the official [Rucio  clients repo](https://github.com/rucio/containers/tree/master/clients) for more information.  

## Rucio-clients version change

Change the version in the Dockerfile's `BASETAG`. 

## Run with X.509 authentication

### Using environment variables

```bash
$ docker run -e RUCIO_CFG_ACCOUNT=<myrucioaccount> -v /path/to/client.crt:/opt/rucio/etc/client.crt -v /path/to/client.key:/opt/rucio/etc/client.key -it --name=rucio-client rucio-client
```

### Using environment variables and a X.509 proxy

```bash
$ voms-proxy-init
$ docker run -e RUCIO_CFG_ACCOUNT=<myrucioaccount> -e RUCIO_CFG_AUTH_TYPE=x509_proxy -e RUCIO_CFG_CLIENT_X509_PROXY=/opt/proxy/x509up_uNNNN -v /tmp:/opt/proxy -it --name=rucio-client rucio-client
```

### Using a bespoke rucio.cfg

```bash 
$ docker run -e RUCIO_CFG_ACCOUNT=<myrucioaccount> -v /path/to/rucio.cfg:/opt/rucio/etc/rucio.cfg -v /path/to/client.crt:/opt/rucio/etc/client.crt -v /path/to/client.key:/opt/rucio/etc/client.key -it --name=rucio-client rucio-client
```

## Run with userpass authentication

```bash
$ docker run -e RUCIO_CFG_ACCOUNT=<myrucioaccount> -e RUCIO_CFG_AUTH_TYPE=userpass -e RUCIO_CFG_USERNAME=<myrucioname> -e RUCIO_CFG_PASSWORD=<myruciopassword> -it --name=rucio-client rucio-client
```
