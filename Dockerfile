FROM kamailio/kamailio-ci:5.4

RUN rm -rf /etc/kamailio/*

COPY ./kamailio.cfg /kamailio.cfg
COPY ./tls.cfg /tls.cfg
COPY ./dispatcher.list /dispatcher.list

COPY ./entry.sh /entry.sh

VOLUME ["/etc/kamailio"]

ENTRYPOINT ["/entry.sh"]