FROM progrium/busybox
RUN opkg-install openssh-client

ADD keygen.sh /opt/keygen.sh
RUN chmod 755 /opt/keygen.sh

CMD ["/opt/keygen.sh"]
