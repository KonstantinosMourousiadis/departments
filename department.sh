#!/bin/bash


DEPARTMENTS=("Engineering" "Sales" "IS")

for DEPT in "${DEPARTMENTS[@]}"; do
    echo "Setting up $DEPT department..."

    
    DEPT_DIR="/$DEPT"
    mkdir "$DEPT_DIR"

    
    groupadd "$DEPT"

    #department administrator
    ADMIN_USER="${DEPT}_admin"
    useradd -m -s /bin/bash -g "$DEPT" "$ADMIN_USER"

    # two users for the department
    for i in 1 2; do
        USER="${DEPT}_user$i"
        useradd -m -s /bin/bash -g "$DEPT" "$USER"
    done

    # set ownership and permissions
    chown "$ADMIN_USER:$DEPT" "$DEPT_DIR"
    chmod 770 "$DEPT_DIR"  # Only admin and group have full access
    chmod +t "$DEPT_DIR"   # Sticky bit prevents deletion by others

    # confidential document
    CONF_FILE="$DEPT_DIR/confidential.txt"
    echo "This file contains confidential information for the department." > "$CONF_FILE"
    chown "$ADMIN_USER:$DEPT" "$CONF_FILE"
    chmod 640 "$CONF_FILE"  # Only admin can modify the file
done

echo "Setup complete."
