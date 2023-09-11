#!/bin/bash

dest="/var/backup"
home_dir="/home"


if [ ! -d "$dest" ]; then
 mkdir -p "$dest"
fi

CURRENT_DATE=$(date "+%d-%b-%Y-%H-%M-%S")


for USER_HOME in "$home_dir"/*; do
        if [ -d "$USER_HOME" ]; then
                USER=$(basename "$USER_HOME")

                echo "Utilisateur : $USER"

                backup_dir="$dest"/"$USER"
                mkdir -p "$backup_dir"

                find "$USER_HOME" -type f -size +10M -exec tar -czvf "$backup_dir"/"_fichiers_de_plus_de_10_MO_$CURRENT_DATE.tar.gz" {} \;
                find "$USER_HOME" -type f -ctime -7 -exec tar -czvf "$backup_dir"/"_fichiers_crees_moins_7_jours_$CURRENT_DATE.tar.gz" {} \;
                find "$USER_HOME" -type f -mtime -7 -exec tar -czvf "$backup_dir"/"_fichiers_modifies_depuis_7_jours_$CURRENT_DATE.tar.gz" {} \;
                find "$USER_HOME" -type d -name '.*' -o type f -name '.*' -exec tar -czvf "$backup_dir"/"_fichiers_et_repertoires_cachés.tar.gz" {} \;
        fi
done



