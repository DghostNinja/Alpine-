# Use Alpine as the base image
FROM alpine:latest

# Install SSH, Bash, and other necessary tools
RUN apk update && apk add --no-cache openssh bash

# Create a user with a password for SSH access
RUN adduser -D -s /bin/bash myuser && \
    echo "myuser:${PASSWORD}" | chpasswd

# SSH Configuration
RUN mkdir -p /run/sshd && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    ssh-keygen -A

# Fix permissions for SSH keys
RUN chmod 600 /etc/ssh/ssh_host_*_key && \
    chmod 644 /etc/ssh/ssh_host_*_key.pub

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
