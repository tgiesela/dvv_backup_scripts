#1. run backup in mysql to get the database backup
docker exec -it mysql /backup/database_backup.sh

#2. run backup in domain to get the dc-backup 
docker exec -it pdc /usr/sbin/samba_backup

#3. configuration data from payara
docker cp payara:/opt/payara41/glassfish/domains/domain1/config/ /dockerbackup/payara/

#Rsync with remote NAS
/dockerbackup/rsync_data.sh

