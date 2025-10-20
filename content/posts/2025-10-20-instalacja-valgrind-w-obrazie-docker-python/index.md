+++
title = 'Instalacja Valgrind w obrazie Docker Python'
slug = 'instalacja-valgrind-w-obrazie-docker-python'
description = ''
date = '2025-10-20'
lastmod = '2025-10-20'
authors = ['matrixik']
categories = [
  'programowanie'
]
tags = ['docker', 'valgrind']
+++

Problem: domyślny Dockerowy obraz Python-a nie pozwala na instalację Valgrind-a.

Rozwiązanie: brakuje mu prawidłowych repozytoriów Debiana więc trzeba dodać je ręcznie na czas korzystania z Valgrind-a:

```docker
FROM python:3.11.10

ENV PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

# For Valgrind #
RUN echo "deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list

RUN set -ex && \
    # Update package index and install security updates
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        valgrind && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*
```
