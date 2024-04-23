#!/bin/bash

# Name of the running Docker container
CONTAINER_NAME="ansible-container"

# Name of the directory to create inside the container
DIRECTORY_NAME="test-project"

# Local file paths
HOSTS_FILE="../../inventories/ansible/hosts.ini"
PLAYBOOK_FILE="../../playbooks/ansible/test-project-playbook.yml"

# Enter the running container and create the directory
echo "Entering the container and creating the $DIRECTORY_NAME directory..."
docker exec -it "$CONTAINER_NAME" bash -c "
  mkdir -p $DIRECTORY_NAME
  cd $DIRECTORY_NAME
"

# Copy local files to the container's directory
echo "Copying files to the container..."
docker cp "$HOSTS_FILE" "$CONTAINER_NAME:/$DIRECTORY_NAME/hosts.ini"
docker cp "$PLAYBOOK_FILE" "$CONTAINER_NAME:/$DIRECTORY_NAME/playbook.yml"

# Re-enter the container to verify the directory and files
echo "Verifying the files in the container..."
docker exec -it "$CONTAINER_NAME" bash -c "
  cd $DIRECTORY_NAME
  ls
"

echo "Script execution completed."
