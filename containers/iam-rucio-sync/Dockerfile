# Should point latest version of `vre-base-ops` image
ARG BASETAG=v0.1.0

FROM ghcr.io/vre-hub/vre-base-layer-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"

WORKDIR $HOME

# clone repo
COPY iam-sync.conf requirements.txt sync_iam_rucio.py ./
RUN pip install -r requirements.txt

ENTRYPOINT ["/bin/bash"]
