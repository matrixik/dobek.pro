+++
title = 'Docker: zbieranie logów z kontenerów do Logstash'
slug = 'docker-zbieranie-logow-z-kontenerow-do-logstash'
description = ''
date = '2017-10-23'
lastmod = '2017-10-23'
authors = ['matrixik']
categories = [
  'DevOps'
]
tags = ['docker', 'logstash', 'logspout']
+++

## Problem

Mamy wiele kontenerów działających na jednej/wielu maszynach i chcemy zbierać
logi ze wszystkich do Logstash-a (część Elastic Stack, dawniej ELK).


## Możliwe rozwiązania

Jest kilka możliwości, jak "zawsze" wybieramy tą która najlepiej spełnia
nasze potrzeby.

Większość jest opisana w
[Top 5 Docker logging methods to fit your container deployment strategy][log-methods]:

+ Aplikacja wysyła logi prosto to serwisu zbierającego (u nas Logstash)
+ Zapisujemy logi do wolumenów Docker-a
+ Korzystamy z [Docker-owego drivera logów][docker-logging]
+ Dedykowany kontener zbierający logi, jeden na całą maszynę
+ Podejście Sidecar, każdy kontener ma swój, dedykowany kontener zbierający logi

Nie będę się tutaj rozpisywał o każdej z nich. Są dobrze opisane pod powyższym
linkiem.

Jest jeden problem z każdym z tych rozwiązań: nie ma obsługi wielolinijkowych
("multiline") logów ponieważ Docker każdą linijkę traktuje jako oddzielny log.
Niestery nie zapowiada się żeby to naprawili:
[log driver should support multiline #22920][moby-multiline].

## Dedykowany kontener zbierający logi

Opiszę tą która według mnie jest najbardziej przyjazna dla
użytkownika końcowego i wymaga stosunkowo mało konfiguracji.

Będziemy potrzebowali dwie rzeczy:

1. Wszystkie serwisy w kontenerach są skonfigurowane do wysyłania logów na
   `STDOUT` i `STDERR`
2. Jeden dodatkowy kontener zawierający dostosowany do nas [Logspout][logspout]

Konfiguracja pierwszego punktu jest zależna od serwisu który działa
w kontenerze i każdy będzie musiał sam to przygotować.

### Logspout

Jest to program przekazujący logi z kontenerów Docker-a w wybrane przez
nas miejsce.
Sam też jest przystosowany do działania w kontenerze. Ma możliwość rozszerzania
funkcjonalności z czego skorzystamy przy routownaiu logów do Logstash-a.

W momencie kiedy Logspout zostanie włączony łączy się on z Docker-em
na maszynie, pobiera informacje o wszystkich uruchomionych kontenerach i łączy
się z nimi pobierając wszystkie logi z `STDOUT` oraz `STDERR`. Następnie
wysyła je do skonfigurowanego miejsca docelowego.

Żeby współdziałał on z Logstash-em musimy skompilować go razem z modułem
[logspout-logstash][logspout-logstash].

W tym celu w folderze gdzie będziemy trzymać pliki dla naszego kontenera
musimy stworzyć trzy pliki potrzebna nam do zbudowania Logspout-a
z potrzebnym modułem.

Można je skopiować z folderu
https://github.com/gliderlabs/logspout/tree/master/custom
lub wykorzystać poniższe przykłady:

`build.sh`
```bash
#!/bin/sh

# DO NOT REMOVE, file used by Logspout build process

apk add --update go build-base git mercurial ca-certificates
mkdir -p /go/src/github.com/gliderlabs
cp -r /src /go/src/github.com/gliderlabs/logspout
cd /go/src/github.com/gliderlabs/logspout || exit
export GOPATH=/go
go get -v
go build -ldflags "-X main.Version=$1" -o /bin/logspout
apk del go git mercurial build-base
rm -rf /go /var/cache/apk/* /root/.glide
```

`modules.go`
```go
// DO NOT REMOVE, file used by Logspout build process

package main

import (
	_ "github.com/gliderlabs/logspout/transports/tcp"
	_ "github.com/gliderlabs/logspout/transports/udp"
	_ "github.com/looplab/logspout-logstash"
)
```

I najważniejszy dla nas
`Dockerfile`
```dockerfile
FROM gliderlabs/logspout:master

ENV ROUTE_URIS=logstash+tcp://127.0.0.1:5610

RUN apk add --no-cache tini

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/logspout"]
```

Do plików `build.sh` oraz `modules.go` nie odnosimy się bezpośrednio w naszym
`Dockerfile`. Są one wykorzystywane już przez sam proces budowania
Lobspout-a dzięki dyrektywie Docker-a `ONBUILD`
w <https://github.com/gliderlabs/logspout/blob/master/Dockerfile#L9-L11>.

Ustawiamy zmienną środowiskową `ROUTE_URIS` która wskazuje gdzie znajduje
się Logstash oraz po jakim protokole chcemy się z nim łączyć. Ma ona format
`ROUTE_URIS=logstash://host:port` i domyślnie wysyła logi za pomocą `UDP`.
W tym przypadku skonfigurowałem połącznie po `TCP`.

### Logstash

Musimy jeszcze odpowiednio skonfigurować Logstash-a żeby czekał na logi
na odpowiednim porcie.

W pliku konfiguracyjnym ustawiamy `input` w następujący sposób:
```
input {
  udp {
    port  => 5610
    codec => json
  }
  tcp {
    port  => 5610
    codec => json
  }
}
```

Wszystkie logi zawierają teraz dane z jakiego kontenera zostały zebrane:
```
"docker": {
    "hostname": "866e2ca94f5f",
    "id": "866e2ca94f5fe11d57add5a78232c53dfb6187f04f6e150ec15f0ae1e1737731",
    "image": "centos:7",
    "name": "/ecstatic_murdock"
}
```

Możemy dodatkowo opisać kontenery dodatkowymi danymi za pomocą zmiennych
środowiskowych np. tagami za pomocą `LOGSTASH_TAGS="docker,produkcja"`
albo polami Logstash-a przy użyciu `LOGSTASH_FIELDS="service=mysql"`.
Dokładniejszy opis opcji konfiguracyjnych można przeczytać na stronie
modułu: [Available configuration options][logspout-logstash-config].

Jeśli chcemy możemy ustawić filtr który zmienia nam dane o kontenerze Docker-a
oraz dodatkowe tagi (np. `service`) na dane w `dimensions`:
```ruby
filter {
    ruby {
        code => '
            event["dimensions"] = []
            event["docker"].each do |key, value|
              unless event["docker"][key].nil?
                event["dimensions"].push([key, value].to_s)
              end
            end
            if event.to_hash.has_key?("service")
              event["dimensions"].push(["service", event["service"]].to_s)
            end
        '
    }
    mutate {
        remove_field => ["docker"]
    }
}
```

Na koniec dobrym pomysłem jeszcze będzie wykluczenie kontenera Logspout oraz
samego Logstash-a ze zbierania logów żeby nie doszło do zapętlenia. Zrobimy
to używając zmiennej środowiskowej `LOGSPOUT=ignore` dla każdego z kontenerów,
więcej info: [Ignoring specific containers][logspout-ignore-logs].


## Zakończenie

Jeśli wszystko zostało dobrze skonfigurowane logi powinny zacząć spływać
do Elasticsearch-a oraz być widoczne w Kibanie.


[ELK]: Elasticsearch Logstash Kibana
[log-methods]: https://www.loggly.com/blog/top-5-docker-logging-methods-to-fit-your-container-deployment-strategy/
[docker-logging]: https://docs.docker.com/engine/admin/logging/overview/
[logspout]: https://github.com/gliderlabs/logspout
[logspout-logstash]: https://github.com/looplab/logspout-logstash
[logspout-logstash-config]: https://github.com/looplab/logspout-logstash#available-configuration-options
[logspout-ignore-logs]: https://github.com/gliderlabs/logspout#ignoring-specific-containers
[moby-multiline]: https://github.com/moby/moby/issues/22920
