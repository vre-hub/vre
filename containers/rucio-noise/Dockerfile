ARG BASETAG=v0.1.0
 
# To be changed to specific version+hsa
FROM ghcr.io/vre-hub/vre-base-layer-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"

WORKDIR /home/user/

# # clone repo
RUN git clone https://github.com/vre-hub/vre.git
RUN pip install -r /home/user/vre/infrastructure/scripts/cron_scripts/rucio-noise/requirements.txt

ENTRYPOINT ["/bin/bash"]
