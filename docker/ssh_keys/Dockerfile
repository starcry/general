FROM alpine:latest
RUN apk add --no-cache openssh

ADD keygen.sh /opt/keygen.sh
RUN chmod 755 /opt/keygen.sh

CMD ["/opt/keygen.sh"]
