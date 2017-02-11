#!/bin/bash

. utils.sh

# Vraag datum op sla op in DATUM, DAGVANMAAND, DAGVANJAAR, JAAR
DATUM=$(date +%C%y%m%d)
DAGVANMAAND=$(date +%d)
DAGVANJAAR=$(date +%j)
JAAR=$(date +%C%y)
MAAND=$(date +%m)
USER=$(id -nu)
RSYNC=/usr/bin/rsync
RSYNCLOG=/backup/rsyncbackup.log

say "Backup started"
# Variabelen voor bestandslocaties

# Map voor het lokaal opslaan van de backups
BACKUPDIR=/backup

# Locatie van de historyfile waarin wordt bijgehouden wat er de
# laatste keer is gebackupped
HISTORYFILE=${BACKUPDIR}/history.inc

# Hierin worden de folders die gebackupped moeten worden opgegeven
#BACKUPFOLDERS='/dockerbackup /home/samba/userdata /usr/local/backups'
BACKUPFOLDERS='/dockerdata/sambashares'

# exclude specific file extensions
EXCLUDEPART=--exclude='*.jpg'

Maandbackup() {
    FNAME=$1

    say "Maandbackup naar ${FNAME}"

    if [ -f ${FNAME}.tgz ]; then
        say "Backupfile ${FNAME}.tgz bestaat al, backup heeft al gedraaid"
        exit
    fi

    # History verwijderen en complete backup maken in zipfile
    rm ${HISTORYFILE}

    tar --gzip --create --file=${FNAME}.tgz \
	     --listed-incremental=${HISTORYFILE} \
	     ${EXCLUDEPART} ${BACKUPFOLDERS} 

    # Delete maandfiles ouder dan 1 maanden
    find ${BACKUPDIR} -name "maandbackup*" -mtime +93 -exec rm -f {} \;

}

Dagbackup() {
    FNAME=$1

    say "Dagbackup naar ${FNAME}"
    if [ -f ${FNAME}.tgz ]; then
        say "Backupfile ${FNAME}.tgz bestaat al, backup heeft al gedraaid"
        exit
    fi

    # zipfile maken met alleen de gewijzigde bestanden
    tar --gzip --create --file=${FNAME}.tgz \
        --listed-incremental=${HISTORYFILE} \
	--exclude=${EXCLUDEPART} ${BACKUPFOLDERS} 
  
    # Delete dagfiles ouder dan 32 dagen
    find ${BACKUPDIR} -name "dagbackup*" -mtime +32 -exec rm -f {} \;

}

DAGBACKUPNAAM=${BACKUPDIR}/dagbackup${JAAR}${DAGVANJAAR}
MAANDBACKUPNAAM=${BACKUPDIR}/maandbackup${JAAR}${MAAND}

if [ ${USER} != 'root' ]; then
	say "Moet door 'root' gestart worden"
	exit
fi

# Decide to make Daily or Monthly Backup 

if [ ${DAGVANMAAND} = 01 ]; then

   Maandbackup ${MAANDBACKUPNAAM}

else

   Dagbackup ${DAGBACKUPNAAM}

fi

say "Backup created"



