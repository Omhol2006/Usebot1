# set base image (host OS)
FROM python:3.9

# set the working directory in the container
WORKDIR /app/

RUN apt -qq update
RUN apt -qq install -y --no-install-recommends \
    curl \
    git \
    gnupg2 \
    unzip \
    wget \
    ffmpeg

# install chrome
RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    # -f ==> is required to --fix-missing-dependancies
    dpkg -i ./google-chrome-stable_current_amd64.deb; apt -fqqy install && \
    # clean up the container "layer", after we are done
    rm ./google-chrome-stable_current_amd64.deb

# install chromedriver
RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip  && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ && \
    # clean up the container "layer", after we are done
    rm /tmp/chromedriver.zip

ENV GOOGLE_CHROME_DRIVER /usr/bin/chromedriver
ENV GOOGLE_CHROME_BIN /usr/bin/google-chrome-stable

# install node-js
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm i -g npm

# install rar
RUN curl -sLO http://archive.ubuntu.com/ubuntu/pool/multiverse/r/rar/rar_7.10-2_amd64.deb && \
    curl -sLO https://archive.ubuntu.com/ubuntu/pool/multiverse/u/unrar-nonfree/unrar_6.1.5-1ubuntu0.1_amd64.deb && \
    apt install -y ./*.deb && rm *.deb

    RUN apt-get -qq update
RUN apt-get -qq install -y --no-install-recommends gnupg2 pv

#add latest mkvtoolnix
# add latest mkvtoolnix
# install mkvtoolnix (native bullseye)
RUN apt-get update && apt-get install -y \
    mkvtoolnix \
    && rm -rf /var/lib/apt/lists/*



#--------------------------------------

RUN apt-get update && apt-get install -y aria2 \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get -qq update
RUN apt-get install mediainfo -y

# copy the content of the local src directory to the working directory
COPY . .

# install dependencies
RUN pip install -r requirements.txt

# command to run on container start
CMD [ "bash", "./run" ]
