#
# This is a multi-stage build.
# Actual build is at the very end.
#

FROM library/ubuntu:xenial AS build

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
RUN apt-get update && \
    apt-get install -y \
        python-software-properties \
        software-properties-common \
        apt-utils

RUN mkdir -p /build/image
WORKDIR /build
RUN apt-get download \
        libaio1 \
        liblz4-1 \
        libnuma1 \
        libstdc++6 \
        libwrap0 \
        zlib1g \
        mysql-server-5.7 \
        mysql-server-core-5.7
RUN for file in *.deb; do dpkg-deb -x ${file} image/; done

WORKDIR /build/image
RUN rm -rf \
        etc/apparmor.d \
        etc/init \
        etc/init.d \
        etc/logcheck \
        etc/logrotate.d \
        etc/mysql/* \
        lib/systemd \
        usr/bin \
        usr/share/apport \
        usr/share/doc \
        usr/share/gcc-5 \
        usr/share/gdb \
        usr/share/lintian \
        usr/share/man \
        usr/share/mysql/*.sql \
        usr/share/mysql/*.txt \
        usr/share/mysql/echo_stderr \
        usr/share/mysql/magic \
        usr/share/mysql/mysql-log-rotate \
        usr/share/mysql/mysql-systemd-start \
        usr/share/mysql/mysqld_multi.server \
        var/lib/mysql-upgrade && \
    mkdir -p \
        etc/mysql/conf.d \
        var/run/mysqld \
        var/lib/mysql \
        var/lib/mysql-files && \
    chmod 0770 var/lib/mysql-files && \
    echo "!includedir /etc/mysql/conf.d/" > etc/mysql/my.cnf

COPY init.sh etc/
COPY init.sql usr/share/mysql/

FROM clover/base

WORKDIR /
COPY --from=build /build/image /

VOLUME ["/var/lib/mysql"]

CMD ["sh", "/etc/init.sh"]

EXPOSE 3306
