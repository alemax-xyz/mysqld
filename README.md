## Mysqld docker image
MySQL is a widely used, open-source relational database management system (RDBMS).

This image is based on official mysql server packages for Ubuntu Xenial and is built on top of [clover/base](https://hub.docker.com/r/clover/base/).
It contains `mysqld` only. Consider using [clover/mysql](https://hub.docker.com/r/clover/mysql/) for administration and database upgrades.

Data volume is located at `/var/lib/mysql`. It will be initialized with `/usr/share/mysql/init.sql` on the first run with no password set to `root` user.
