ARG BASETAG=v0.1.1

FROM ghcr.io/vre-hub/vre-base-ops:${BASETAG}
LABEL maintainer="VRE Team @ CERN 22/23 - E. Garcia, E. Gazzarrini, D. Gosein"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

# Workdir is /home
COPY produce_noise.sh requirements.txt rses.txt /home/
RUN chmod +x ./produce_noise.sh
RUN pip install -r /home/requirements.txt

# TODO check certs inside destination folder, it already contains a CA file
COPY ca-bundle.pem /etc/pki/tls/certs/ca-bundle.pem

ENTRYPOINT ["/bin/bash"]
