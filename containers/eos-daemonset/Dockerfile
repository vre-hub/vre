FROM centos:7

RUN yum -y install curl gnupg epel-release

ADD yum-repo/eos7-depend.repo /etc/yum.repos.d/eos7-depend.repo
ADD yum-repo/eos7-tag.repo /etc/yum.repos.d/eos7-tag.repo

# Install EOS fuse client
RUN yum update -y \
    && yum install -y zeromq-devel jemalloc-devel librichacl-devel \
    && yum install -y \
    eos-fuse \
    eos-fusex \
    initscripts \
    jq \
    procps-ng \
    && yum clean all

# ESCAPE grid-security and VOMS setup
RUN yum update -y \
    && yum install -y wget voms-clients-java xrootd-client

ADD yum-repo/EGI-trustanchors.repo /etc/yum.repos.d/EGI-trustanchors.repo
RUN yum install -y ca-policy-egi-core

RUN mkdir -p /etc/vomses \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses

RUN mkdir -p /etc/grid-security/vomsdir/escape \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

# Install CERN CA certs from CERN maintained mirrors
COPY ./linuxsupport7s-stable.repo /etc/yum.repos.d/
RUN yum install -y CERN-CA-certs

# Setup merged CERN CA file
# RUN mkdir /certs \
#     && touch /certs/rucio_ca.pem \
#     && cat /etc/grid-security/certificates/CERN-Root-2.pem >> /certs/rucio_ca.pem \
#     && cat /etc/grid-security/certificates/CERN-GridCA.pem >> /certs/rucio_ca.pem

ADD mount.sh /mount.sh
ADD conf/fuse.eulake.conf.json /etc/eos/fuse.eulake.conf
ADD conf/fuse.sss.keytab /etc/eos/fuse.sss.keytab
RUN chmod 400 /etc/eos/fuse.sss.keytab

CMD ["/mount.sh"]
