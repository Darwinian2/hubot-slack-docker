# Docker 1.5.0

FROM node:0.12.7
MAINTAINER Rex Tsai <rex.cc.tsai@gmail.com>

# Usual update / upgrade
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && \
        apt-get install -y redis-server git-core
# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install coffee-script, hubot
RUN npm install -g yo generator-hubot coffee-script

# Working enviroment
ENV BOTDIR /opt/bot
RUN install -o nobody -d ${BOTDIR}
ENV HOME ${BOTDIR}
WORKDIR ${BOTDIR}

# Install Hubot
USER nobody
RUN yo hubot --name="Hubot" --defaults

# Install slack adapter
RUN npm install hubot-slack --save

# Entrypoint
ENTRYPOINT ["/bin/sh", "-c", "cd ${BOTDIR} && bin/hubot --adapter slack"]