FROM quay.io/eclipse/che-sidecar-java:8

ENV HOME=/home/theia
ENV VERSION=1.6.0
ARG user=theia
ARG group=theia
ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${group} -s /bin/sh -m ${user} && \
    mkdir -p ${HOME}/.daml && chown -R theia:theia ${HOME}
    
USER theia

RUN echo 'hosts: files dns' > /etc/nsswitch.conf && \
    curl https://get.daml.com | sh -s $VERSION \
    && printf "auto-install: false\nupdate-check: never\n" >> ${HOME}/.daml/daml-config.yaml
    
ENV PATH="${HOME}/.daml/bin:${PATH}"
