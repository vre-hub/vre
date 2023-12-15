ARG BASETAG=0.9.1-alpha.3
ARG BUILD_DATE
 
# To be changed to specific version+hsa
FROM reanahub/reana-server:${BASETAG}
LABEL maintainer="VRE TEAM @ CERN 2023 - E. Gazzarrini, E. Garcia"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre
LABEL org.label-schema.build-date=${BUILD_DATE}

# Workdir is /home
COPY requirements.txt add_reana_users.py generate_email_list.py /home/

RUN pip install -r /home/requirements.txt

ENTRYPOINT ["/bin/bash"]


