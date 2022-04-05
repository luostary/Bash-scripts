#!/bin/bash

WEBCONTAINER="YOUR HTTP CONTAINER NAME"
DBCONTAINER="YOUR DB CONTAINER NAME"
DBPASSWORD="YOUR PASSWORD FOR ROOT MYSQL USER"
RAWDBNAME=`docker exec ${WEBCONTAINER} sh -c 'grep -o "dbname=[a-zA-Z0-9]\+" /var/www/ast/config/private_conf/db.php'`
#echo $rawDbName
DBNAME="${RAWDBNAME/dbname=/}"
DBNAME="astTestDb"
DUMPNAME="dump2.sql"
 
command="mysqldump -u root -p${DBPASSWORD} ${DBNAME} > /tmp/${DUMPNAME}"
echo "creating dump..."
#echo $command
docker exec ${DBCONTAINER} sh -c "$command"
 
echo "creating tar..."
docker exec $DBCONTAINER sh -c "cd /tmp && tar -czf dump.tar.gz ${DUMPNAME}"
 
echo "coping tar into db server..."
docker cp $DBCONTAINER:tmp/dump.tar.gz /tmp
 
echo "coping tar to web server..."
docker cp /tmp/dump.tar.gz $WEBCONTAINER:tmp/dump.tar.gz
sudo rm /tmp/dump.tar.gz
 
echo "moving tar to uploads folder..."
docker exec $WEBCONTAINER sh -c "mv /tmp/dump.tar.gz /var/www/ast/web/uploads/dump.tar.gz"
echo "Done"
