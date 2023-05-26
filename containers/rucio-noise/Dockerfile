ARG BASETAG=v0.1.0
 
FROM ghcr.io/vre-hub/vre-base-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"


# Copy files inside the container
COPY ./rses.txt ./requirements.txt ./produce_noise.sh ./
RUN chmod +x ./produce_noise.sh
RUN pip install -r requirements.txt

ENTRYPOINT ["/bin/bash"]
