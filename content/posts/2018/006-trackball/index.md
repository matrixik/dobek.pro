+++
draft = true
title = 'Logitech TrackMan Marble i Linux'
slug = 'logitech-trackman-marble-i-linux'
description = ''
date = '2018-12-10'
lastmod = '2018-12-10'
authors = ['matrixik']
categories = [
  'linux'
]
tags = ['trackaball', 'linux']
+++

Trackball Logitech TrackMan Marble
https://www.logitech.com/en-hk/product/156

https://askubuntu.com/questions/675405/disabling-back-for-a-logitech-trackball

https://ubuntuforums.org/showthread.php?t=65471

http://xahlee.info/kbd/trackball.html

https://jcastellssala.com/2016/10/29/logitech-trackman-in-linux/

https://www.tanstaafl.co.uk/2018/08/logitech-marble-mouse-on-ubuntu-18-04-and-mint-19/

`xinput list`

```
⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ Logitech USB Trackball                  	id=10	[slave  pointer  (2)]
⎜   ↳ Dell Dell Wired Multimedia Keyboard     	id=12	[slave  pointer  (2)]
⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
    ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
    ↳ Power Button                            	id=6	[slave  keyboard (3)]
    ↳ Video Bus                               	id=7	[slave  keyboard (3)]
    ↳ Power Button                            	id=8	[slave  keyboard (3)]
    ↳ Sleep Button                            	id=9	[slave  keyboard (3)]
    ↳ Dell Dell Wired Multimedia Keyboard     	id=11	[slave  keyboard (3)]
    ↳ Dell WMI hotkeys                        	id=13	[slave  keyboard (3)]
```

`xinput list-props "Logitech USB Trackball"`
`xinput set-button-map "Logitech USB Trackball" 1 2 3 4 5 6 7 0 8`

`/usr/share/X11/xorg.conf.d/70-logitech-trackman.conf`

```
Section "InputClass"
    Identifier  "Marble Mouse"
    MatchProduct "Logitech USB Trackball"
    MatchIsPointer "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
    Option "EmulateWheel" "true"
    # Move back button to the right side
    Option "ButtonMapping" "1 2 3 4 5 6 7 0 8"
    Option "ScrollButton" "8"
    Option "ScrollMethod" "button"
    Option "MiddleEmulation" "on"
EndSection
```
