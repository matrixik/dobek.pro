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
