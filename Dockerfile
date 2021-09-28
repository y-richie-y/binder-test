# syntax=docker/dockerfile:1
FROM python:3.7.12-slim
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
RUN apt update
RUN apt install -y git make gcc g++
USER ${NB_USER}
# RUN python3.7 -m venv env
# RUN source env/bin/activate
RUN pip install --no-cache-dir notebook
RUN pip install --no-cache-dir jupyterhub
RUN pip install cython numpy