FROM phusion/baseimage:0.9.22                                                                      
MAINTAINER Martin Polak

ENV HOME /root

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen cs_CZ.UTF-8
ENV LANG cs_CZ.UTF-8

ENV NODE_VERSION 9.11.1

RUN (apt-get update && \
     DEBIAN_FRONTEND=noninteractive \
     apt-get install -y build-essential software-properties-common \
                        zlib1g-dev libssl-dev libreadline-dev libyaml-dev \
                        libxml2-dev libxslt-dev sqlite3 libsqlite3-dev \
                        vim git byobu wget curl unzip tree exuberant-ctags \
                        build-essential cmake python python-dev gdb)

RUN (apt-get install -y npm)

# Add a non-root user
RUN (useradd -m -d /home/docker -s /bin/bash docker && \
     echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers)

USER docker
ENV HOME /home/docker
WORKDIR /home/docker

RUN (git config --global user.email "nigol@nigol.cz" && \
  git config --global user.name "Martin Polak")
  
# Vim configuration
RUN (mkdir /home/docker/.vim && mkdir /home/docker/.vim/bundle && \
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    git clone https://github.com/nigol/vimrc && \
    cp vimrc/vimrc .vimrc && \
    cd /home/docker/.vim/bundle && \
    git clone https://github.com/tpope/vim-fugitive.git && \
    git clone https://github.com/airblade/vim-gitgutter && \
    git clone https://github.com/vim-airline/vim-airline.git && \
    git clone https://github.com/ctrlpvim/ctrlp.vim.git)

# Prepare SSH key file
RUN (mkdir /home/docker/.ssh && \
    touch /home/docker/.ssh/id_rsa && \
    chmod 600 /home/docker/.ssh/id_rsa)

USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN (npm install -g create-react-app)
RUN (wget https://nodejs.org/dist/v8.11.1/node-v8.11.1-linux-x64.tar.xz && \
    tar -xvf node-v8.11.1-linux-x64.tar.xz && \
    cp -R node-v8.11.1-linux-x64/bin/* /usr/local/bin/ && \
    cp -R node-v8.11.1-linux-x64/lib/* /usr/local/lib/ && \
    cp -R node-v8.11.1-linux-x64/share/* /usr/local/share/ && \
    rm node-v8.11.1-linux-x64.tar.xz && \
    rm node-v8.11.1-linux-x64 -rf)
    
CMD [“/bin/sh”]
