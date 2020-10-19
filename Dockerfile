FROM quay.io/eclipse/che-sidecar-java:8

ENV HOME=/home/theia
ENV VERSION=1.6.0

RUN mkdir -p ${HOME}/.daml && chown -R user:user ${HOME}/.daml 

USER user

RUN echo 'hosts: files dns' > /etc/nsswitch.conf && \
    curl https://get.daml.com | sh -s $VERSION \
    && printf "auto-install: false\nupdate-check: never\n" >> ${HOME}/.daml/daml-config.yaml
    
ENV PATH="${HOME}/.daml/bin:${PATH}"
