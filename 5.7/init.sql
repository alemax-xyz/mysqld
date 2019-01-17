DELETE FROM `mysql`.`user` WHERE `User` <> 'root';
UPDATE `mysql`.`user` SET `Host` = '%', `password_expired` = 'N' WHERE `User` = 'root';
FLUSH PRIVILEGES;
