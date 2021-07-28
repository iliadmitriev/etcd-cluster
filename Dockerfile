FROM alpine:3.14

MAINTAINER Ilia Dmitriev ilia.dmitriev@gmail.com

ENV ETCD_DIR=/opt/etcd \
    ETCD_DATA=/var/lib/etcd \
    ETCD_USER=etcd \
    ETCD_GROUP=etcd \
    PATH=$PATH:$ETCD_DIR

RUN set -xe \
    # install python3 and pip
    && apk add --no-cache python3 py3-requests \

    # Install etcd
    && echo "Current etcd arch is $(uname -m)" \
    && adduser -D -H -h $ETCD_DIR -u 120 etcd etcd \
    && case $(uname -m) in \
        "aarch64") \
            wget https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-arm64.tar.gz \
                -O /tmp/etcd-v3.5.0.tar.gz \
            ;; \
        "x86_64") \
            wget https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-amd64.tar.gz \
                -O /tmp/etcd-v3.5.0.tar.gz \
            ;; \
        esac \
    && mkdir /opt/etcd \
    && tar -xvf /tmp/etcd-v3.5.0.tar.gz -C $ETCD_DIR --strip-components=1 \
    && chown -R $ETCD_USER:$ETCD_GROUP $ETCD_DIR \
    && mkdir -p $ETCD_DATA \
    && chown -R $ETCD_USER:$ETCD_GROUP $ETCD_DATA \

# cleanup
    && rm -rf /tmp/* \
    && find /var/log -type f -exec truncate --size 0 {} \; \
    && rm -rf /var/cache/apk/*

COPY --chown=etcd etcd-cluster.py $ETCD_DIR/etcd-cluster.py

USER $ETCD_USER

STOPSIGNAL SIGINT

EXPOSE 2379 2380

CMD ["/usr/bin/python3", "/opt/etcd/etcd-cluster.py"]