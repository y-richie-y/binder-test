# syntax=docker/dockerfile:1
FROM python:3.7.12-slim
RUN pip install --no-cache-dir notebook
RUN pip install --no-cache-dir jupyterhub
RUN pip install cython numpy