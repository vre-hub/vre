ARG BASEIMAGE=rucio/rucio-server
ARG BASETAG=release-1.30.0
 
FROM $BASEIMAGE:$BASETAG
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

# cleanup yum cache
RUN yum upgrade -y \
    && yum clean all \
    && rm -rf /var/cache/yum

# install useful tools
RUN yum -y install git htop wget voms-clients-cpp
RUN pip install --upgrade pip

USER root

# EGI trust anchors
RUN curl -Lo /etc/yum.repos.d/egi-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo \
    && yum update -y 

RUN yum -y install gfal2* python3-gfal2 xrootd-client voms-clients-java 
RUN yum -y install ca-certificates ca-policy-egi-core

# Install CERN CA certs from CERN maintained mirrors
# This will add a `CERN-bundle.pem` file (among others) into `/etc/pki/tls/certs/`
COPY ./linuxsupport7s-stable.repo /etc/yum.repos.d/
RUN yum install -y CERN-CA-certs

# ESCAPE VOMS setup
RUN mkdir -p /etc/vomses \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses
RUN mkdir -p /etc/grid-security/vomsdir/escape \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

# Install latest kubectl
RUN curl -o /usr/bin/kubectl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl

WORKDIR /home

ENTRYPOINT ["/bin/bash"]
