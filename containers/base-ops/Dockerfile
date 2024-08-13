ARG BASEIMAGE=rucio/rucio-server
ARG BASETAG=release-34.6.0
ARG BUILD_DATE

FROM ${BASEIMAGE}:${BASETAG}
LABEL maintainer="VRE Team @ CERN 23/24 - E. Garcia, G. Guerrieri"
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
RUN dnf -y install git htop wget voms-clients-cpp
RUN python3 -m pip install --upgrade pip

# EGI trust anchors
RUN curl -Lo /etc/yum.repos.d/egi-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo \
    && dnf update -y

RUN dnf -y install gfal2* python3-gfal2 xrootd-client voms-clients-java
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

# Install latest kubectl
RUN curl -o /usr/bin/kubectl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x /usr/bin/kubectl

WORKDIR /home

ENTRYPOINT ["/bin/bash"]
