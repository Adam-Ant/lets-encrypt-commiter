FROM spritsail/alpine:3.9

RUN apk add --no-cache certbot git bash\
 && pip3 install certbot-dns-cloudflare \
 && mkdir -p /lets-encrypt /config

ADD *.sh /lets-encrypt/

RUN chmod +x /lets-encrypt/*

VOLUME /config

ENTRYPOINT ["bash", "-c", "/lets-encrypt/lets-encrypt.sh"]
