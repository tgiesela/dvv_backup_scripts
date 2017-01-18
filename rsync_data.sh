#!/bin/bash

. /dockerbackup/utils.sh

RSYNC=/usr/bin/rsync
RSYNCLOG=/dockerbackup/log/rsync_data.log
RSYNCPWD=/dockerbackup/rsync.psw
REMOTESAMBADIR=rsync://rsync@gieselaar.dyndns.org/Backup/Rsync/cloud/data
REMOTEDOMAINDIR=rsync://rsync@gieselaar.dyndns.org/Backup/Rsync/cloud/domain
REMOTEGFDIR=rsync://rsync@gieselaar.dyndns.org/Backup/Rsync/cloud/gf
REMOTEOPENVPNDIR=rsync://rsync@gieselaar.dyndns.org/Backup/Rsync/cloud/openvpn
REMOTEDBDIR=rsync://rsync@gieselaar.dyndns.org/Backup/Rsync/cloud/db

DBDIR=/dockerbackup/db
DATADIR=/dockerdata/sambashares/
GFDIR=/dockerbackup/payara/
OPENVPNDIR=/dockerdata/openvpn/
DOMAINDIR=/dockerbackup/samba/

say "Starting rsync data"

# add database backup to remote backup
${RSYNC} --archive --verbose --dirs --delete --hard-links \
        --password-file=${RSYNCPWD}  \
        ${DATADIR} ${REMOTESAMBADIR} >& ${RSYNCLOG}.data

# synchronize the Glassfish/Payara configuration
${RSYNC} --archive --verbose --dirs --delete --hard-links \
        --password-file=${RSYNCPWD}  \
        ${GFDIR} ${REMOTEGFDIR}  >& ${RSYNCLOG}.gf

#synchronize the Openvpn files
${RSYNC} --archive --verbose --dirs --delete --hard-links \
        --password-file=${RSYNCPWD}  \
        ${OPENVPNDIR} ${REMOTEOPENVPNDIR}  >& ${RSYNCLOG}.openvpn

# add database backup to remote backup
${RSYNC} --archive --verbose --dirs --delete --hard-links \
        --password-file=${RSYNCPWD}  \
        ${DBDIR} ${REMOTEDBDIR} >& ${RSYNCLOG}

# synchronize the domain controller data and configuration
${RSYNC} --archive --verbose --dirs --delete --hard-links \
        --password-file=${RSYNCPWD}  \
        ${DOMAINDIR} ${REMOTEDOMAINDIR} >& ${RSYNCLOG}

say "Rsync completed"
say "Rsync data completed"


