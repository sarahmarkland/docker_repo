# As of 2023-09-13, Ubuntu 22.04 is the latest LTS release but project ask for 18.04
FROM ubuntu:18.04

# This will stop openssh-server installer from opening a dialog,
# which would require human input
ENV DEBIAN_FRONTEND=noninteractive

# Update APT and upgrade currently installed software
# Install software as needed this includes the SSH to connect to the container
RUN apt-get update && apt-get upgrade -y \
    curl \
    sudo \
    openssh-server\
    git

# Install other software as needed
# Install Node.js 12.11.x LTS release
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh && \
    sudo bash nodesource_setup.sh && \
    sudo apt-get install -y nodejs && \
    rm nodesource_setup.sh
# Install Jest, Babal, and ESLint globally
RUN npm install -g \
    jest \
    babel-jest \
    @babel/core \
    @babel/preset-env \
    @babel/cli \
    eslint
# Example:
# RUN apt-get install -y nodejs npm
# RUN npm install -g create-react-app
# RUN apt-get install -y python3 python3-pip
# RUN pip3 install flask

# Allow root to login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Allow password to login via SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set SSH password to "root"
RUN echo 'root:root' | chpasswd

# Start the SSH service
RUN service ssh start

# Setup git config
RUN git config --global user.email sarah.markland@icloud.com
RUN git config --global user.name sarahmarkland

# Example of how to include your SSH key for GitHub:
# COPY host-machine-github-private-key /root/.ssh/github-private-key
# RUN chmod 600 /root/.ssh/github-private-key
# RUN echo 'eval `ssh-agent -s`' >> /root/.bashrc
# RUN echo 'ssh-add ~/.ssh/github' >> /root/.bashrc

# Run the SSH service on container startup
CMD ["/usr/sbin/sshd", "-D"]