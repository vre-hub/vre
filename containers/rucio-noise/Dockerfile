ARG BASETAG=v0.1.1

FROM ghcr.io/vre-hub/vre-base-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

#added to test gfal uploads nor working
RUN yum install -y epel-release.noarch && \
    yum clean all && \
    rm -rf /var/cache/yum
    
RUN yum upgrade -y && \
    yum clean all && \
    rm -rf /var/cache/yum
    
RUN yum -y install wget gfal2*

RUN yum -y install https://repo.ius.io/ius-release-el7.rpm && \
    yum install -y voms-clients-java gfal2-all gfal2-util python3-gfal2 xrootd-client

    
# Workdir is /home
COPY produce_noise.sh requirements.txt rses.txt /home/
RUN chmod +x ./produce_noise.sh
RUN pip install -r /home/requirements.txt

# TODO check certs inside destination folder, it already contains a CA file
COPY ca-bundle.pem /etc/pki/tls/certs/ca-bundle.pem

ENTRYPOINT ["/bin/bash"]
