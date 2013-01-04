## Future

## 1.1.0
* add support for multiple clusters in the same chef environment
* add creation of /etc/zookeeper file, which has a list of zookeeper nodes.

## 1.0.5
* removing vpod reside from hive-env.sh

## 1.0.4
* Install to /usr/share/hive to match the /usr/share/hadoop folder setup

## 1.0.3
* Log to /var/log/hive not /tmp

## 1.0.2
* Use the install_dir variable for hadoop not install_stage_dir

## 1.0.1:
* Download Hive from a URL that is an attribute
* Download the hive source to the chef cache dir and not /tmp
* Fix a few mode defs
* Better comments
* Header comment blocks

## 1.0.0:
* Initial release with a changelog