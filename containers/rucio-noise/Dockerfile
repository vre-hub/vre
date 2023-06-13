ARG BASETAG=v0.1.0

FROM ghcr.io/vre-hub/vre-base-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"

# Workdir is /home
COPY produce_noise.sh requirements.txt rses.txt /home/
RUN pip install -r /home/requirements.txt

# TODO check certs inside destination folder, it already contains a CA file
# COPY ca-bundle.pem /etc/pki/tls/certs/

ENTRYPOINT ["/bin/bash"]
