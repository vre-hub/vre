ARG BASETAG=v0.1.0
 
# To be changed to specific version+hsa
FROM ghcr.io/vre-hub/vre-base-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"

# Workdir is /home
COPY requirements.txt sync_iam_rucio.py iam-sync.conf /home/

RUN pip install -r /home/requirements.txt

ENTRYPOINT ["/bin/bash"]
