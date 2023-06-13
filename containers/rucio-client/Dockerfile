ARG BASEIMAGE=rucio/rucio-clients

ARG BASETAG=release-1.30.0
FROM $BASEIMAGE:$BASETAG
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"

USER root

# EGI trust anchors
RUN curl -Lo /etc/yum.repos.d/EGI-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo \
    && yum -y update

RUN yum clean metadata
RUN yum -y install wget ca-certificates ca-policy-egi-core

# CERN cert 
COPY ./linuxsupport7s-stable.repo /etc/yum.repos.d/
RUN yum install -y CERN-CA-certs

# ESCAPE VOMS setup
RUN mkdir -p /etc/vomses \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses
RUN mkdir -p /etc/grid-security/vomsdir/escape \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

# ESCAPE Rucio setup
ADD --chown=user:user rucio.cfg.escape.j2 /opt/user/rucio.cfg.j2

# install reana-client 
ENV LC_ALL=en_US.UTF-8
RUN pip install --upgrade pip
RUN pip install reana-client

USER user
WORKDIR /home/user

ENTRYPOINT ["/bin/bash"]