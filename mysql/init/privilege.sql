CREATE DATABASE IF NOT EXISTS msghub;
CREATE USER 'msghub'@'%' IDENTIFIED BY 'msghub';
GRANT ALL PRIVILEGES ON msghub.* TO 'msghub'@'%';

CREATE DATABASE IF NOT EXISTS donation;
CREATE USER 'donation'@'%' IDENTIFIED BY 'donation';
GRANT ALL PRIVILEGES ON donation.* TO 'donation'@'%';

CREATE DATABASE IF NOT EXISTS rd2;
CREATE USER 'rd2'@'%' IDENTIFIED BY 'rd2';
GRANT ALL PRIVILEGES ON rd2.* TO 'rd2'@'%';

FLUSH PRIVILEGES;