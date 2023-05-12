ARG BASETAG=latest
 
# To be changed to specific version+hsa
FROM ghcr.io/vre-hub/vre-base-layer-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN"

WORKDIR /home/user/

# # clone repo
RUN git clone https://github.com/vre-hub/vre.git
RUN pip install -r /home/user/vre/infrastructure/scripts/cron_scripts/rucio-noise/requirements.txt

ENTRYPOINT ["/bin/bash"]
