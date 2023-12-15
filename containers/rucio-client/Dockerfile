# ARG TAG should be updated with the latest-1 version in case no tag is provided
ARG TAG=v1.0.0-rc.1
ARG BUILD_DATE

FROM ghcr.io/vre-hub/vre-base-ops:${TAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
LABEL org.label-schema.build-date=${BUILD_DATE}

USER root
# install reana-client 
RUN pip install reana-client==0.9.1

# WORKDIR /home set on the base-ops image
USER user
# ESCAPE Rucio setup
ADD --chown=user:user rucio.cfg.escape.j2 /opt/user/rucio.cfg.j2
ENV LC_ALL=en_US.UTF-8

ENTRYPOINT ["/bin/bash"]