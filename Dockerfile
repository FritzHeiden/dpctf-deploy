FROM ubuntu:18.04

# install packages
RUN apt update &&\
    apt install git curl python python-pip virtualenv npm nodejs -y


ENV APP_DIR /home/ubuntu

RUN mkdir $APP_DIR &&\ 
    useradd -d $APP_DIR ubuntu &&\
    chown -R ubuntu $APP_DIR
WORKDIR $APP_DIR
RUN rm /bin/sh &&\
    ln -s /bin/bash /bin/sh
USER ubuntu


RUN mkdir DPCTF && cd DPCTF
WORKDIR DPCTF
RUN git init &&\
    git remote add origin https://github.com/cta-wave/dpctf-test-runner.git

ARG commit

USER root
RUN npm install --global https://github.com/fraunhoferfokus/wptreport.git#wmats2018
USER ubuntu

RUN git fetch origin $commit
RUN git reset --hard FETCH_HEAD

RUN ./import-tests.sh

EXPOSE 8000

CMD ./wpt serve-wave --report
