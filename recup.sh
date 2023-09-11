#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Utilisation : $0 Date_Debut Date_Fin"
    echo "Exemple : $0 'Sep 10 16:58:26' 'Sep 10 17:01:40'"
    exit 1
fi

DATE_DEBUT="$1"
DATE_FIN="$2"

LOG_DIR="/var/log/"
LOG_FILES=("auth.log" "auth.log.1")

temp_dir=$(mktemp -d)

for LOG_FILE in "${LOG_FILES[@]}"; do
    echo "Traitement du fichier : $LOG_DIR$LOG_FILE"

    # Créer un fichier de sortie unique pour chaque fichier de journal
    output_file="${LOG_FILE}_connexions_${DATE_DEBUT}_to_${DATE_FIN}.log"

    # Utiliser awk pour extraire les lignes entre les dates spécifiées
    awk -v start="$DATE_DEBUT" -v end="$DATE_FIN" '$1" "$2" "$3 >= start && $1" "$2" "$3 <= end' "$LOG_DIR$LOG_FILE" > "$output_file"

    echo "Connexions entre $DATE_DEBUT et $DATE_FIN ont été sauvegardées dans $output_file"
done

# Crée une archive tar.gz avec les fichiers extraits
# Crée une archive tar.gz avec les fichiers extraits
backup_filename="log_extraction_$(date +%Y_%m_%d_%H_%M_%S).tar.gz"
tar -czvf "/var/backup/$backup_filename" -C "$temp_dir" .

# Nettoie le répertoire temporaire
rm -rf "$temp_dir"

echo "Données collectées ont été archivées dans /var/backup/$backup_filename"






