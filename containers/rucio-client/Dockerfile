ARG BASETAG=v0.1.0

FROM ghcr.io/vre-hub/vre-base-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"

USER root
# ESCAPE Rucio setup
ADD --chown=user:user rucio.cfg.escape.j2 /opt/user/rucio.cfg.j2

# install reana-client 
ENV LC_ALL=en_US.UTF-8
RUN pip install reana-client

USER user

ENTRYPOINT ["/bin/bash"]
