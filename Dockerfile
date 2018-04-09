FROM couchbase:enterprise-5.1.0

COPY configure_lab.sh /opt/couchbase
COPY bu.zip /opt/couchbase

CMD ["/opt/couchbase/configure_lab.sh"]
