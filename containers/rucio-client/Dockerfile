ARG BASETAG=v0.1.2

FROM ghcr.io/vre-hub/vre-base-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

USER root
# install reana-client 
RUN pip install reana-client==0.9.1

# WORKDIR /home set on the base-ops image
USER user
# ESCAPE Rucio setup
ADD --chown=user:user rucio.cfg.escape.j2 /opt/user/rucio.cfg.j2
ENV LC_ALL=en_US.UTF-8

ENTRYPOINT ["/bin/bash"]
