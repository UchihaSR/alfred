# Alfred

My daily driver shell scripts

## Why does it exist?

Most of these are written by myself in order to indulge my laziness
and/or in order for me to escape doing something actually worth while.

Hopefully you will get some use out of these
and in return, I, some gratification.

## Highlights

-  **Syncing**

   -  Phone (via wifi)
   -  Google drive
   -  Git
   -  Arch & AUR packages
   -  IMAP mail server

-  **FFmpeg scripts**

   -  Trim videos
   -  Join videos
   -  Reduce volume
   -  Add music to video
   -  Make GIFs

-  **Recording**

   -  Screenshot
   -  Screencast
   -  Audio
   -  Webacm

-  **Battery**

   -  Periodic checking
   -  Charge blocking (for battery longevity)

-  Universal compiler for all kinds of files
-  Custom launch script (xdg-open replacement)
-  Instant googleing
-  Bluetooth headset connect
-  Update local git repos
-  Make bootable USB (linux & windows (for normies!))
-  Correct DPI setter
-  Terminal Preview
-  And much more

## Installation

```sh
git clone https://github.com/salman-abedin/alfred.git && cd alfred && sudo make install
```

## Usage

| Command                       | Effect                                                                          |
| ----------------------------- | ------------------------------------------------------------------------------- |
| `connected`                   | Checks if wifi & internet is up or not                                          |
| `preview`                     | Previewer script for lf                                                         |
| `launch-devour`               | xdg-open alternative combined with terminal swallowing                          |
| `watchmen --dots`             | Makes symbolic links to my home directory when there is a change in my dotfiles |
| `watchmen --mail`             | Refreshes my statusbar module on changes in inbox                               |
| `alfred --dpi`                | Sets the correct dpi for my display resolution                                  |
| `alfred --background shuffle` | Shuffles up my background                                                       |
| `alfred --background reel 1m` | Changes background each minute                                                  |
| `mirror --phone`              | Syncs my phone & local files                                                    |
| `mirror --arch`               | Syncs all of my packages                                                        |
| `mirror --git`                | Syncs all of my repositories                                                    |
| `mirror --mail`               | Syncs my mails                                                                  |
| `panel --date-time`           | Generates date & time panel module                                              |
| `panel --wifi`                | Generates wifi link strength panel module                         |
| `panel --mailbox`             | Generates unread mail count panel module module                                 |
| `panel --noti-stat`           | Generates notification on/off status panel module module                        |
| `panel --vol-stat`            | Generates volume level panel module module                                      |
| `panel --sys-stat`            | Generates system temperature, cpu load & memory status panel module module      |
| `torrent --add`               | Adds torrent to transmission and notifies instantly                             |
| `torrent --downloaded`        | Notfies when a torrent is downloaded                                            |

## Uninstallation

```sh
sudo make uninstall
```
