FROM quay.io/eclipse/che-sidecar-java:8

ENV HOME=/home/theia
ENV VERSION=1.6.0
ENV SDK=0.13.12

RUN mkdir -p ${HOME}/.daml && addgroup -S user && adduser -S user -G user && \
    chown -R user:user ${HOME} && \
    echo 'hosts: files dns' > /etc/nsswitch.conf  && \
    apk update && apk add curl bash ncurses

USER user

RUN cd ${HOME} && curl https://get.daml.com | sh -s $VERSION \
    && printf "auto-install: false\nupdate-check: never\n" >> ${HOME}/.daml/daml-config.yaml && \
    daml install ${SDK}
    
USER root

RUN  for f in "/home/theia"; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done 

ADD etc/entrypoint.sh /entrypoint.sh

ENV PATH="${HOME}/.daml/bin:${PATH}"
