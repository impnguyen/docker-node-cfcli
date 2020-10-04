FROM ubuntu:18.04
LABEL maintainer="MPN"
LABEL version="0.1"

# Install required packages for next installs
RUN apt-get update && apt-get install -y wget gnupg2 curl chromium-browser build-essential

# Set chrome environment variable for karma tests
ENV CHROME_BIN /usr/bin/chromium-browser

# Install Cloud Foundry CLI
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN apt-get update && apt-get install -y cf7-cli

# Setup alias for CF7 command
#RUN echo "alias cf='cf7'" >> ~/.bashrc
#RUN echo -e '#!/bin/bash\ncf7 "$@"' > /usr/bin/cf && chmod +x /usr/bin/cf

# Install community repository and MTA plugin
RUN cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
RUN cf install-plugin multiapps -f

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Update npm to latest version
RUN npm install npm@latest -g

# install mta build tools
RUN npm install mbt

# Run cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Run command line
CMD /bin/bash
