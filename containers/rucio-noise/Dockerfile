# ARG BASETAG=v0.1.1

# FROM ghcr.io/vre-hub/vre-base-ops:${BASETAG}
# LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"
# LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
# ARG BUILD_DATE
# LABEL org.label-schema.build-date=$BUILD_DATE

# #added to test gfal uploads nor working
# RUN yum install -y epel-release.noarch && \
#     yum clean all && \
#     rm -rf /var/cache/yum
    
# RUN yum upgrade -y && \
#     yum clean all && \
#     rm -rf /var/cache/yum
    
# RUN yum -y install wget gfal2*

# RUN yum -y install https://repo.ius.io/ius-release-el7.rpm && \
#     yum install -y voms-clients-java gfal2-all gfal2-util python3-gfal2 xrootd-client

    
# # Workdir is /home
# COPY produce_noise.sh requirements.txt rses.txt /home/
# RUN chmod +x ./produce_noise.sh
# RUN pip install -r /home/requirements.txt

# # TODO check certs inside destination folder, it already contains a CA file
# COPY ca-bundle.pem /etc/pki/tls/certs/ca-bundle.pem

# ENTRYPOINT ["/bin/bash"]


ARG BASEIMAGE=rucio/rucio-server
ARG BASETAG=release-1.30.0
# ARG RUCIO_VERSION=1.30.0
 
FROM $BASEIMAGE:$BASETAG
# cleanup yum cache
RUN yum upgrade -y \
    && yum clean all \
    && rm -rf /var/cache/yum
# install useful tools
RUN yum -y install git htop wget voms-clients-cpp
WORKDIR /home/user/
# # clone repos
RUN git clone https://github.com/vre-hub/vre.git
# install python requirments
RUN pip install --upgrade pip
# RUN echo $(pwd) # Editting to trigger CI
RUN pip install -r /home/user/vre/containers/rucio-noise/requirements.txt
#RUN pip install rucio-clients==$RUCIO_VERSION
#RUN pip install rucio==$RUCIO_VERSION
USER root
# EGI trust anchors
RUN curl -o /etc/yum.repos.d/EGI-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo \
    && yum -y update

RUN yum install -y gfal2* python3-gfal2
RUN yum install -y ca-certificates ca-policy-egi-core
# RUN curl -Lo /etc/pki/tls/certs/CERN-bundle.pem https://gitlab.cern.ch/plove/rucio/-/raw/7121c7200257a4c537b56ce6e7e438f0b35c6e48/etc/web/CERN-bundle.pem
RUN cp /home/user/vre/containers/rucio-noise/ca-bundle.pem /etc/pki/tls/certs/CERN-bundle.pem

# ESCAPE VOMS setup
RUN mkdir -p /etc/vomses \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses
RUN mkdir -p /etc/grid-security/vomsdir/escape \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc
# Install latest kubectl
RUN curl -o /usr/bin/kubectl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl
ENTRYPOINT ["/bin/bash"]
