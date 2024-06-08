#!/bin/bash

# Définir les variables
CONFIG_DIR="$HOME/ceremonyclient/node/.config"
KEYS_FILE="$CONFIG_DIR/keys.yml"
CONFIG_FILE="$CONFIG_DIR/config.yml"
STORE_DIR="$CONFIG_DIR/store"
BACKUP_DIR="$HOME/"
# Fonction de sauvegarde
function backup {
    TIMESTAMP=$(date +"%d%b")

    # Sauvegarder les fichiers keys.yml et config.yml dans un fichier zip une seule fois
    if [ ! -f "$BACKUP_DIR/config_backup.zip" ]; then
        zip -j "$BACKUP_DIR/config_backup.zip" "$KEYS_FILE" "$CONFIG_FILE"
    fi

    # Sauvegarder le dossier store complet dans un fichier zip, supprimer l'ancien zip
    STORE_BACKUP="$BACKUP_DIR/store_backup_$TIMESTAMP.zip"
    rm -f "$BACKUP_DIR/store_backup_*.zip"
    
    # Changer de répertoire pour garantir des chemins relatifs dans l'archive zip
    cd "$CONFIG_DIR"
    zip -r -1 "$STORE_BACKUP" "store"

    # Vérifier si les sauvegardes ont réussi
    if [ $? -eq 0 ]; then
        echo "Sauvegarde réussie: $STORE_BACKUP"
    else
        echo "Échec de la sauvegarde"
    fi

    # Revenir au répertoire initial
    cd -
}

# Boucle infinie pour effectuer la sauvegarde toutes les 24 heures
while true; do
    backup
    # Attendre 24 heures
    sleep 86400
done
