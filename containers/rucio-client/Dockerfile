# VRE rucio-client image is the only which BASE is not the vre-base-ops image

ARG BASEIMAGE=rucio/rucio-clients
ARG BASETAG=release-1.30.0
ARG BUILD_DATE

FROM ${BASEIMAGE}:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
LABEL org.label-schema.build-date=${BUILD_DATE}

USER root

# cleanup yum cache
RUN yum upgrade -y \
    && yum clean all \
    && rm -rf /var/cache/yum

# install useful tools
RUN yum -y install git htop wget
RUN pip install --upgrade pip

# EGI trust anchors
RUN curl -Lo /etc/yum.repos.d/egi-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo \
    && yum update -y


RUN yum -y install ca-certificates ca-policy-egi-core

# Install CERN CA certs from CERN maintained mirrors
# This will add a `CERN-bundle.pem` file (among others) into `/etc/pki/tls/certs/`
COPY ./linuxsupport7s-stable.repo /etc/yum.repos.d/
RUN yum install -y CERN-CA-certs

# ESCAPE VOMS setup
RUN mkdir -p /etc/vomses \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses \
    && mkdir -p /etc/grid-security/vomsdir/escape \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

# install reana-client 
ENV LC_ALL=en_US.UTF-8
RUN pip install reana-client==0.9.2

USER user
WORKDIR /home/user

# ESCAPE Rucio client configuration
ADD --chown=user:user rucio.cfg.escape.j2 /opt/user/rucio.cfg.j2
ADD --chown=user:user rucio.default.cfg.escape /opt/user/rucio.default.cfg

ENTRYPOINT ["/bin/bash"]
