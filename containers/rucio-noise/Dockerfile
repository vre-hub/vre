# ARG TAG should be updated with the latest-1 version in case no tag is provided
ARG TAG=v1.0.0-rc.2
ARG BUILD_DATE

FROM ghcr.io/vre-hub/vre-base-ops:${TAG}
LABEL maintainer="VRE Team @ CERN 23/24 - E. Garcia, G. Guerrieri"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
LABEL org.label-schema.build-date=${BUILD_DATE}
    
# Workdir is /home
COPY produce_noise.sh requirements.txt rses.txt /home/
RUN chmod +x ./produce_noise.sh
RUN python -m pip install -r /home/requirements.txt

ENTRYPOINT ["/bin/bash"]

