# Rucio-noise container

This image is set up as a cronjob on the `VRE` infrastructure. When run, the container will trigges a series of transfers between the different configured `RSE`s (RUCIO Storage Elements) of the infrastructure to test the health of the `vre-RUCIO` instance.

## Rucio-noise version change

This container depends on the `vre-base-ops` container, which in turn depends on the `rucio/rucio-server:release-1.30.0`. Therefore, to change the version of the rucio-client, please change the `vre-base-ops` container first.   