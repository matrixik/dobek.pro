+++
title = 'Proste zarzadzanie NVM za pomocą pluginu Zsh'
slug = 'proste-zarzadzanie-nvm-za-pomoca-pluginu-zsh'
description = ''
date = '2017-10-18'
lastmod = '2017-10-18'
authors = ['matrixik']
categories = [
  'Programowanie'
]
tags = ['nvm', 'node', 'zsh', 'zplug']
+++

Do zarządzania NVM wykorzystuję plugin do Zsh [zsh-nvm][zsh-nvm].
Instaluje on dla mnie NVM i ułatwia jego aktualizację.

## Założenia

+ Linux
+ Zsh ustawiony jako domyślna powłoka

Do łatwiejszego zarządzania wtyczkami dla Zsh wykorzystuję [zplug][zplug].

## Konfiguracja i instalacja

W pliku `.zshrc` dodajemy:
```bash
# Sprawdzamy czy zplug jest zainstalowany
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --force
else
  source ~/.zplug/init.zsh
fi

# zplug sam może się aktualizować
zplug "zplug/zplug", hook-build:"zplug --self-manage"

export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
zplug "lukechilds/zsh-nvm"
zplug "lukechilds/zsh-better-npm-completion", defer:3

# zplug check zwraca true jeśli wszystkie pluginy są zainstalowane
# Jeśli zwróci false, odpal zplug install
if ! zplug check; then
    zplug install
fi

# Załaduj pluginy i dodaj komendy do $PATH
zplug load #--verbose
```

Teraz wystarczy otworzyć nowy terminal i zadzieje się trochę magii:

1. zostanie zainstalowany `zplug`
2. następnie on zainstaluje `zsh-nvm`
3. `zsh-nvm` zainstaluje NVM-a

Sprawdzamy wersję za pomocą `nvm --version`. Od tego momentu możemy
go aktualizować za pomocą `nvm upgrade`. Jeśli aktualizacja coś popsuje,
cofamy się do poprzedniej wersji z wykorzystaniem `nvm revert`.

Eksportuję tutaj również dwie zmienne środowiskowe:

1. `export NVM_LAZY_LOAD=true` - ładuje NVM dopiero przy pierwszym użyciu
   zamiast przy każdym odpalaniu nowego terminala.
2. `export NVM_AUTO_USE=true` - automatycznie przełącza bądź instaluje
   odpowiednią wersję Node z pliku `.nvmrc`. NVM musi być załadowany w danym
   terminalu (czyli używasz dowolnej komendy `nvm` albo
   `export NVM_LAZY_LOAD=false`)

## Inne przydatne komendy

**Aktualizacja do ostatnie stabilnej wersji Node:**

`nvm install lts/* --reinstall-packages-from=node`

**Ustawianie domyślnej stabilnej wersji Node:**

`nvm alias default lts/*`

Jako bonus mamy również lepsze autouzupełnianie w terminalu do NPM dzięki
[zsh-better-npm-completion][npm-completion].

[zsh-nvm]: https://github.com/lukechilds/zsh-nvm/
[zplug]: https://github.com/zplug/zplug
[npm-completion]: https://github.com/lukechilds/zsh-better-npm-completion
