# ARG TAG should be updated with the latest-1 version in case no tag is provided
ARG TAG=v1.0.0-rc.1
ARG BUILD_DATE
 
# To be changed to specific version+hsa
FROM ghcr.io/vre-hub/vre-base-ops:${TAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
LABEL org.label-schema.build-date=${BUILD_DATE}

# Workdir is /home
COPY requirements.txt sync_iam_rucio.py iam-sync.conf /home/

RUN pip install -r /home/requirements.txt

ENTRYPOINT ["/bin/bash"]


