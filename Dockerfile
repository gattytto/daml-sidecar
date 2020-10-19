FROM quay.io/eclipse/che-sidecar-java:8

ENV HOME=/home/theia
ENV VERSION=1.6.0

RUN mkdir -p ${HOME}/.daml && addgroup -S theia && adduser -S theia -G theia && \
    chown -R theia:theia ${HOME} && \
    echo 'hosts: files dns' > /etc/nsswitch.conf 

USER theia

RUN cd ${HOME} && curl https://get.daml.com | sh -s $VERSION \
    && printf "auto-install: false\nupdate-check: never\n" >> ${HOME}/.daml/daml-config.yaml
    
USER root

RUN  for f in "/home/theia"; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done 

ADD etc/entrypoint.sh /entrypoint.sh

ENV PATH="${HOME}/.daml/bin:${PATH}"
