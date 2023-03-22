ARG BASEIMAGE=rucio/rucio-server
ARG BASETAG=release-1.30.0
# ARG RUCIO_VERSION=1.30.0

FROM $BASEIMAGE:$BASETAG

# cleanup yum cache
RUN yum upgrade -y && \
yum clean all && \
rm -rf /var/cache/yum

# install useful tools
RUN yum -y install git htop voms-clients-cpp

WORKDIR /home/user/

# # clone repos
RUN git clone https://github.com/cern-vre/cern-vre/containers.git

# install python requirments
RUN pip install --upgrade pip

RUN echo $(pwd)

RUN pip install -r /home/user/containers/iam-rucio-sync/requirements.txt

# RUN pip install rucio-clients==$RUCIO_VERSION
# RUN pip install rucio==$RUCIO_VERSION

USER root
# EGI trust anchors
RUN curl -o /etc/yum.repos.d/EGI-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo \
&& yum -y update

RUN yum -y install wget gfal2*
RUN yum install -y python3-gfal2
RUN yum -y install ca-certificates ca-policy-egi-core
RUN curl -Lo /etc/pki/tls/certs/CERN-bundle.pem https://gitlab.cern.ch/plove/rucio/-/raw/7121c7200257a4c537b56ce6e7e438f0b35c6e48/etc/web/CERN-bundle.pem

# ESCAPE VOMS setup
RUN mkdir -p /etc/vomses \
&& wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses
RUN mkdir -p /etc/grid-security/vomsdir/escape \
&& wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

# Install latest kubectl
RUN curl -o /usr/bin/kubectl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl

ENTRYPOINT ["/bin/bash"]
