+++
title = 'Docker: Wyświetlanie etykiet obrazów'
slug = 'docker-wyswietlanie-etykiet-obrazow'
description = ''
date = '2018-06-11'
lastmod = '2018-06-11'
authors = ['matrixik']
categories = [
  'DevOps'
]
tags = ['docker', 'jq']
+++

Etykiety są przydatne do pozostawiania informacji co znajduje się w obrazie.
Np. z jakiego commita został zbudowany obraz, gdzie znajduje się dokumentacja
itp. Ich założeniem jest żeby łatwo dało się je odczytać przez inne programy
na np. użytek CI. Tak więc standardowo jeśli chcemy je odczytać samodzielnie
to nie wygląda to dobrze gdyż są schowane wśród innych informacji.

Przejdźmy do przykładu wyświetlając wszystkie dane o obrazie:

`docker inspect <nazwa_obrazu>:<tag>`

```bash
λ docker inspect monasca-api:master
[
    {
        "Id": "sha256:ed6ab78a72cd56e81661703afcca3fd2d1fcaf3aa1f248422d2b7eb666fa1d56",
        "RepoTags": [
            "monasca-api:master",
            "monasca-api:master-20180611T122349Z"
        ],
        "RepoDigests": [],
        "Parent": "sha256:9d348d1f688d9396ab59ebc8a1ff01f90bdfa3453120733cc395847c2e0989e6",
        "Comment": "",
        "Created": "2018-06-11T12:24:50.537316628Z",
        "Container": "01ee19423c983db3ab6fc82a4a04520b37fc5bb40248d67f9c2c4e87a0264c02",
        "ContainerConfig": {
            "Hostname": "01ee19423c98",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "LANG=C.UTF-8",
                "GPG_KEY=97FC712E4C024BBEA48A61ED3A5CA953F73C700D",
                "PYTHON_VERSION=3.5.5",
                "PYTHON_PIP_VERSION=10.0.1",
                "ENV=/root/.ashrc",
                "PIP_FORCE_REINSTALL=true",
                "PIP_NO_CACHE_DIR=no",
                "PIP_NO_COMPILE=no",
                "KAFKA_URI=kafka:9092",
                "KAFKA_WAIT_FOR_TOPICS=alarm-state-transitions,metrics",
                "MYSQL_HOST=mysql",
                "MYSQL_USER=monapi",
                "MYSQL_PASSWORD=password",
                "MYSQL_DB=mon",
                "LOG_LEVEL=INFO",
                "STAY_ALIVE_ON_FAILURE=false"
            ],
            "Cmd": [
                "/bin/sh",
                "-c",
                "#(nop) ",
                "CMD [\"/start.sh\"]"
            ],
            "Healthcheck": {
                "Test": [
                    "CMD-SHELL",
                    "python3 healthcheck.py || exit 1"
                ]
            },
            "ArgsEscaped": true,
            "Image": "sha256:9d348d1f688d9396ab59ebc8a1ff01f90bdfa3453120733cc395847c2e0989e6",
            "Volumes": null,
            "WorkingDir": "/app",
            "Entrypoint": [
                "/sbin/tini",
                "-s",
                "--"
            ],
            "OnBuild": null,
            "Labels": {
                "org.opencontainers.image.created": "20180611T122349Z",
                "org.opencontainers.image.licenses": "Apache-2.0",
                "org.opencontainers.image.revision": "dfa49097e07043039afa5879100cd522b46eaad3",
                "org.opencontainers.image.source": "https://git.openstack.org/openstack/monasca-api",
                "org.opencontainers.image.title": "monasca-api",
                "org.opencontainers.image.url": "https://github.com/openstack/monasca-api",
                "org.opencontainers.image.version": "master",
                "org.openstack.constraints_uri": "http://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt?h=master",
                "org.openstack.monasca.python.extra_deps": "gunicorn influxdb python-memcached Jinja2"
            }
        },
        "DockerVersion": "17.12.0-ce",
        "Author": "",
        "Config": {
            "Hostname": "",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "LANG=C.UTF-8",
                "GPG_KEY=97FC712E4C024BBEA48A61ED3A5CA953F73C700D",
                "PYTHON_VERSION=3.5.5",
                "PYTHON_PIP_VERSION=10.0.1",
                "ENV=/root/.ashrc",
                "PIP_FORCE_REINSTALL=true",
                "PIP_NO_CACHE_DIR=no",
                "PIP_NO_COMPILE=no",
                "KAFKA_URI=kafka:9092",
                "KAFKA_WAIT_FOR_TOPICS=alarm-state-transitions,metrics",
                "MYSQL_HOST=mysql",
                "MYSQL_USER=monapi",
                "MYSQL_PASSWORD=password",
                "MYSQL_DB=mon",
                "LOG_LEVEL=INFO",
                "STAY_ALIVE_ON_FAILURE=false"
            ],
            "Cmd": [
                "/start.sh"
            ],
            "Healthcheck": {
                "Test": [
                    "CMD-SHELL",
                    "python3 healthcheck.py || exit 1"
                ]
            },
            "ArgsEscaped": true,
            "Image": "sha256:9d348d1f688d9396ab59ebc8a1ff01f90bdfa3453120733cc395847c2e0989e6",
            "Volumes": null,
            "WorkingDir": "/app",
            "Entrypoint": [
                "/sbin/tini",
                "-s",
                "--"
            ],
            "OnBuild": null,
            "Labels": {
                "org.opencontainers.image.created": "20180611T122349Z",
                "org.opencontainers.image.licenses": "Apache-2.0",
                "org.opencontainers.image.revision": "dfa49097e07043039afa5879100cd522b46eaad3",
                "org.opencontainers.image.source": "https://git.openstack.org/openstack/monasca-api",
                "org.opencontainers.image.title": "monasca-api",
                "org.opencontainers.image.url": "https://github.com/openstack/monasca-api",
                "org.opencontainers.image.version": "master",
                "org.openstack.constraints_uri": "http://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt?h=master",
                "org.openstack.monasca.python.extra_deps": "gunicorn influxdb python-memcached Jinja2"
            }
        },
        "Architecture": "amd64",
        "Os": "linux",
        "Size": 158767110,
        "VirtualSize": 158767110,
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/5be7b47ed9e8ab5f74ee55f026f93022fa865ce4bd272699cf843fdcd7caebe5/diff:/var/lib/docker/overlay2/8d00da288c9db6fa3313d0537203c8702203646a380f83d259a730f5d670761d/diff:/var/lib/docker/overlay2/d653f5a6faf1c5b966968bbdfad7465e88160d9d5d454e5686c10930b43cb3c8/diff:/var/lib/docker/overlay2/d2a179d6e6b9cbd8171160126d145f0db2873b391e53640d3570eb8108f09dcf/diff:/var/lib/docker/overlay2/cf57ca87a9533d2a302bff336a917fc8726b7a01c1ec8a118e97ab8323970c87/diff:/var/lib/docker/overlay2/ee6837d830dee3514bea634ea74df939542b5500c410e059d98b9c03d1cb6521/diff:/var/lib/docker/overlay2/f1cd7a0aa4e595a84f52bf33428fdda10efd3ef32e94f6d06ef510b01db60483/diff:/var/lib/docker/overlay2/0e0e0881dcce5136149c4e8213484be366e48a8de59daee27ef9f704e45df171/diff:/var/lib/docker/overlay2/37e15c48acb011777b45ce0de5e4185ff1dfbcda8cc154acdc24df484aa98c33/diff:/var/lib/docker/overlay2/363981896f78bcae7ead49456934763cdeebc7b253feb7fdecca5892ae803f37/diff:/var/lib/docker/overlay2/b6bf1601986e842eb4bd38c864122233757305c8bd7674f927901eba36dddbbc/diff",
                "MergedDir": "/var/lib/docker/overlay2/79b6f8437624cb0a0543531128207b493b2ed42d2bfd89ed0568833924a45ced/merged",
                "UpperDir": "/var/lib/docker/overlay2/79b6f8437624cb0a0543531128207b493b2ed42d2bfd89ed0568833924a45ced/diff",
                "WorkDir": "/var/lib/docker/overlay2/79b6f8437624cb0a0543531128207b493b2ed42d2bfd89ed0568833924a45ced/work"
            },
            "Name": "overlay2"
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:cd7100a72410606589a54b932cabd804a17f9ae5b42a1882bd56d263e02b6215",
                "sha256:6b68dfad3e66aa09d08f98a86db6fbc9e1be7dee77156c10d8de3154ee288a47",
                "sha256:978a4a912d6e957283a71984a7357820718365e2b0102a51aa17c64689b7b4e9",
                "sha256:47c8a0c355f042f0060589302fac2f5b771653c5810fdf9ea994e5c7125aad2b",
                "sha256:f471f866e2f08ad4f53bce0b976584a65c0b3f048a7071135947af358c7e4cd3",
                "sha256:bf18e43fe69167da9af52fcdde029a4fdbf7c72935d9dec1a252dfb4aa8ba094",
                "sha256:80bfddaf9cfc95165a9e2dd0468d5d0bfd02df487cc0c553532e761f1f7e56c8",
                "sha256:48ac2c13335cfe122e7d00b0c2aff040b6e01bbf290d4bd0028913452606290e",
                "sha256:a6275bca3736ca9408383b48071ef7189e9af29cb265a012dea012af9e3a5341",
                "sha256:7cabf5488b06afcd14c04255b7cc872c90adff3d15c6a008b908bf4f8df9edaf",
                "sha256:201afa77110d06f8d2d405e7907c618e5d95bbd67b67397202ddb0706585c859",
                "sha256:37f8ad75235a64e58f432d40617a003711f5422fc92b6b14a49a152151f2ca2d"
            ]
        },
        "Metadata": {
            "LastTagTime": "2018-06-11T14:24:50.768326627+02:00"
        }
    }
]
```

Nie jest to zbyt czytelne i etykiety ("Labels") są schowane głęboko między
innymi informacjami. Postarajmy się teraz je wyłuskać z tego bałaganu
korzystając z możliwości formatowania danych wyjściowych Docker-a za pomocą
argumentu `--format`:

```bash
λ docker inspect --format "{{ index .Config.Labels }}" monasca-api:master
map[org.openstack.constraints_uri:http://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt?h=master org.opencontainers.image.created:20180611T122349Z org.opencontainers.image.licenses:Apache-2.0 org.opencontainers.image.revision:dfa49097e07043039afa5879100cd522b46eaad3 org.opencontainers.image.source:https://git.openstack.org/openstack/monasca-api org.opencontainers.image.url:https://github.com/openstack/monasca-api org.opencontainers.image.version:master org.opencontainers.image.title:monasca-api org.openstack.monasca.python.extra_deps:gunicorn influxdb python-memcached Jinja2]
```

Trochę lepiej, mamy już tylko jedną linię ale nadal jest to słabo czytelne
dla naszych biednych oczu wlepionych od wielu godzin w ekran komputera.
Na szczęście jak to zwykle bywa gdzieś w odmętach internetu na pewno jest
jakieś narzędzie które nam przyjdzie z pomocą. W tym przypadku jeśli przyjrzymy
się dokładniej danym z `docker inspect` to dojdziemy do wniosku że jest to
ładny JSON. A do parsowania JSON z linii poleceń mamy bardzo fajny [jq][jq].

No to na początek zrzućmy wszystko do `jq`. Nie będę wklejał całego wyjścia
bo wgląda praktycznie tak samo jak pierwsze tylko tym razem ma ładne kolorki.

`docker inspect monasca-api:master | jq`

Wiemy że `Labels` siedzą w `Config` więc teraz skorzystamy z filtrowania
jakie udostępnia nam `jq`:

```bash
λ docker inspect monasca-api:master | jq .[].Config.Labels
{
  "org.opencontainers.image.created": "20180611T122349Z",
  "org.opencontainers.image.licenses": "Apache-2.0",
  "org.opencontainers.image.revision": "dfa49097e07043039afa5879100cd522b46eaad3",
  "org.opencontainers.image.source": "https://git.openstack.org/openstack/monasca-api",
  "org.opencontainers.image.title": "monasca-api",
  "org.opencontainers.image.url": "https://github.com/openstack/monasca-api",
  "org.opencontainers.image.version": "master",
  "org.openstack.constraints_uri": "http://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt?h=master",
  "org.openstack.monasca.python.extra_deps": "gunicorn influxdb python-memcached Jinja2"
}
```

I oto przed naszymi oczami ukazał się pięknie sformatowany tekst który jeszcze
ma ładne kolory ułatwiające szybki przegląd wszystkich etykiet.

Jako dodatkowe uproszczenie można dodać funkcję do terminala:

```bash
function docker-labels() {
    docker inspect $1 | jq .[].Config.Labels;
}
```

I dzięki niej możemy szybko wyświetlić etykiety konkretnego obrazu za pomocą:
`docker-labels monasca-api:master`

{{% center %}}
{{< figure src="docker-labels.png" title="docker-labels" >}}
{{% /center %}}

[jq]: https://stedolan.github.io/jq/
