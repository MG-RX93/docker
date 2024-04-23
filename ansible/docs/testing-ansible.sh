#!/bin/bash

# Step 1: Set up Docker Containers
# Ensure that all three Docker containers are running and accessible from each other.
# If not already done, start them using Docker commands or Docker Compose.

# Step 2: Install Ansible
# Install Ansible on one of the Docker containers.
# Update package index
sudo apt-get update
# Install Python pip (if not already installed)
sudo apt-get install python3-pip -y
# Install Ansible using pip
sudo pip3 install ansible

# Step 3: Get IP addresses of Docker containers
# Get the IP address of container1
container1_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container1)
# Get the IP address of container2
container2_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container2)

# Step 4: Configure Ansible Inventory
# Create Ansible inventory file
cat <<EOT >> hosts
[docker_containers]
container1 ansible_host=$container1_ip
container2 ansible_host=$container2_ip
EOT

# Step 5: Create Ansible Playbook
# Create Ansible playbook file
cat <<EOT >> docker_commands.yml
---
- name: Run commands on Docker containers
  hosts: docker_containers
  tasks:
    - name: Execute command on container1
      docker_container_exec:
        name: container1
        command: "your_command_here"
        detach: yes
        interactive: yes

    - name: Execute command on container2
      docker_container_exec:
        name: container2
        command: "your_command_here"
        detach: yes
        interactive: yes
EOT

# Step 6: Run Ansible Playbook
# Run the Ansible playbook
ansible-playbook -i hosts docker_commands.yml

# Step 7: Verify Execution
# Check the output or logs of the Docker containers to verify execution
