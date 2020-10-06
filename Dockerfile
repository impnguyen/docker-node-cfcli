FROM ubuntu:18.04
LABEL maintainer="MPN"
LABEL version="1"

# Install required packages for next installs
RUN apt-get update && apt-get install -y wget gnupg2 curl build-essential

# Install Cloud Foundry CLI
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN apt-get update && apt-get install -y cf7-cli

# Install community repository and MTA plugin
RUN cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
RUN cf install-plugin multiapps -f

# Install mbt tools
RUN wget https://github.com/SAP/cloud-mta-build-tool/releases/download/v1.0.16/cloud-mta-build-tool_1.0.16_Linux_amd64.tar.gz
RUN tar xvzf cloud-mta-build-tool_1.0.16_Linux_amd64.tar.gz
RUN cp mbt /usr/local/bin/

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Update npm to latest version
RUN npm install npm@latest -g

# Install ui5 build tools cli
RUN npm install --global @ui5/cli

# Install essential packages for ci tasks and create eslintignore
RUN npm install --global eslint

# Run cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Run command line
CMD /bin/bash
