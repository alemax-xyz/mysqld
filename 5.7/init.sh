#!/bin/sh

test -z "$PUID" && PUID=50 || test "$PUID" -eq "$PUID" || exit 2
PUSER=$(getent passwd $PUID | cut -d: -f1)
if [ -z "$PUSER" ]; then
    PUSER=$(getent passwd 50 | cut -d: -f1) && usermod --uid $PUID "$PUSER" || exit 2
fi

test -z "$PGID" && PGID=$(id -g "$PUSER") || test "$PGID" -eq "$PGID" || exit 2
PGROUP=$(getent group $PGID | cut -d: -f1)
if [ -z "$PGROUP" ]; then
    PGROUP=$(id -gn "$PUSER")
    groupmod --gid $PGID "$PGROUP" || exit 2
else
    test $(id -g "$PUSER") -eq $PGID || usermod --gid $PGID "$PUSER" || exit 2
fi

chown $PUID:$PGID /var/lib/mysql /var/lib/mysql-files /var/run/mysqld || exit 2

test -f /var/lib/mysql/auto.cnf || mysqld --user="$PUSER" --initialize --init-file=/usr/share/mysql/init.sql

mysqld --user="$PUSER"
