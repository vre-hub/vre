# VRE rucio-client image is the only which BASE is not the vre-base-ops image

ARG BASEIMAGE=rucio/rucio-clients
ARG BASETAG=release-34.6.0
ARG BUILD_DATE

FROM ${BASEIMAGE}:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
LABEL org.label-schema.build-date=${BUILD_DATE}

USER root

# Install epel-relaseas
RUN dnf install -y epel-release

# cleanup yum cache
RUN dnf upgrade -y \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# install useful tools
RUN dnf -y install git htop wget
RUN python3 -m pip install --upgrade pip

# EGI trust anchors
RUN curl -Lo /etc/yum.repos.d/egi-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo \
    && yum update -y

RUN dnf -y install ca-certificates ca-policy-egi-core

# Install CERN CA certs from CERN maintained mirrors
# This will add a `CERN-bundle.pem` file (among others) into `/etc/pki/tls/certs/`
RUN dnf -y --repofrompath='tmpcern,https://linuxsoft.cern.ch/cern/alma/$releasever/CERN/$basearch/' upgrade almalinux-release --nogpgcheck
RUN dnf install -y CERN-CA-certs

# ESCAPE VOMS setup
RUN mkdir -p /etc/vomses \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses \
    && mkdir -p /etc/grid-security/vomsdir/escape \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

# install reana-client 
ENV LC_ALL=en_US.UTF-8
RUN pip install reana-client==0.9.3

USER user
WORKDIR /home/user

# ESCAPE Rucio client configuration
# Overwrite rucio.default.cfg with the ESCAPE default config file
ADD --chown=user:user rucio.default.cfg.escape /opt/user/rucio.default.cfg

ENTRYPOINT ["/bin/bash"]
