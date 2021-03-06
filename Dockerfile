FROM quay.io/eclipse/che-sidecar-java:8

ENV HOME=/home/theia
ENV VERSION=1.6.0
ENV PATH="${HOME}/.daml/bin:${PATH}"
ENV TERM=xterm

RUN mkdir -p ${HOME}/.daml && addgroup -S user && adduser -S user -G user && \
    chown -R user:user ${HOME} && \
    echo 'hosts: files dns' > /etc/nsswitch.conf  && \
    apk update && apk add curl bash ncurses graphviz ttf-freefont

USER user

RUN cd ${HOME} && curl https://get.daml.com | sh -s $VERSION \
    && printf "auto-install: false\nupdate-check: never\n" >> ${HOME}/.daml/daml-config.yaml
    
USER root

RUN  for f in "/home/theia"; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done 

ADD etc/entrypoint.sh /entrypoint.sh
