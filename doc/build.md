
# Prepare

* Install and configure docker
* Clone yocto runner repository:
```shell
$ git clone https://github.com/denoming/yocto-runner.git
$ cd yocto-runner
$ export TOP_DIR=$PWD
```
* Prepare config archive:
```shell
$ mkdir $TOP_DIR/config && cd $TOP_DIR/config
$ mkdir -p <path1>
$ cd <path1>
$ vim example-application.json
...
$ cd -
<for-each-applications>
...
$ tar -czvf <path1> [<path2>]
```

Note: Preaparation config archive implies creating config files for different stuff (certaing application config, cloud access files, etc.)

# Build

To build J.A.R.V.I.S QEMU image:
* Place `jarvis-config.tar.gz` archive into `yocto-runner/jarvis/config` dir
* Run docker image:
```shell
$ cd yocto-runner
$ bash run.sh jarvis
```
* Update `local.conf` file:
```text
# Specify path to archive with J.A.R.V.I.S config files
JAR_CONFIG_FILE = "${HOME}/yocto-runner/jarvis/config/jarvis-config.tar.gz"
```
* Build image:
```shell
$ bitbake jarvis-dev-image
```

To build J.A.R.V.I.S Raspberry Pi 3 image:
* Place `jarvis-config.tar.gz` archive into `yocto-runner/jarvis-rpi3/config` dir
* Run docker image:
```shell
$ cd yocto-runner
$ bash run.sh jarvis-rpi3
```
* Update `local.conf` file:
```text
# Specify path to archive with J.A.R.V.I.S config files
JAR_CONFIG_FILE = "${HOME}/yocto-runner/jarvis-rpi3/config/jarvis-config.tar.gz"
```
* Build image:
```shell
$ bitbake jarvis-dev-image
```

# Flash

To flash Raspberry Pi 3 image on your SD card you need to perform following steps:
* Mount SD card into your PC;
* Figure out block device name:
```shell
$ lsblk 
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
...
sdd           8:48   1  57,9G  0 disk 
├─sdd1        8:49   1    48M  0 part 
└─sdd2        8:50   1  10,3G  0 part 
...
```
* Unmoun device mount points
* Write image into block device:
```shell
$ cd yocto-runner/jarvis-rpi3/build-rpi3/tmp/deploy/images/raspberrypi3-64
$ sudo dd if=${PWD}/jarvis-dev-image-raspberrypi3-64.rpi-sdimg of=/dev/sdd bs=1M status=progress
```
* Eject SD card from PC

# Configure (Optional)

Depending on what audio device are you going to use this step is optional or not. To enable I2S audio device based you need to do following steps:
* Inject SD card into PC
* Enable I2S audio device in `config.txt` file:
```shell
$ lsblk
...
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sdd           8:48   1  57,9G  0 disk 
├─sdd1        8:49   1    48M  0 part /media/denys/rpi3-64
└─sdd2        8:50   1  10,3G  0 part /media/denys/26a0a8fe-e441-417c-84c7-63e9aea1aa87
$ cd /media/denys/rpi3-64
$ vim config.txt
...
## audio
##     Enable the onboard ALSA audio
##
##     Default off.
##
dtparam=audio=off

# Enable HiFiBerry DAC (I2S audio device)
dtoverlay=hifiberry-dac
...
```

Following changes in `config.txt` are made:
* Enable HiFiBerry DAC audio device
* Disable default audio devices (as a result HiFiBerry device become default)

If you are going to use pluggable USB audio device you don't need above configuration.

# Run

* Inject SD card into device slot
* Power up
* Connect to device by SSH
```shell
$ ssh root@<ip-address>
```
* Check audio device presens (I2S audio device is present):
```shell
$ aplay -l
**** List of PLAYBACK Hardware Devices ****

card 0: sndrpihifiberry [snd_rpi_hifiberry_dac], device 0: HifiBerry DAC HiFi pcm5102a-hifi-0 [HifiBerry DAC HiFi pcm5102a-hifi-0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```
* Play any sound on present audio device.


To play sound in audio device following gstreamer pipeline migh be used:
* play soung on default audio device:
```shell
$ gst-launch-1.0 audiotestsrc wave="ticks" ! audioconvert ! autoaudiosink
```
* play sound on specific audio device (0 - means `card 0` in `aplay -l` output):
```shell
$ gst-launch-1.0 audiotestsrc wave="ticks" ! audioconvert ! alsasink device=hw:0
```
* play audio file WAV format:
```shell
$ gst-launch-1.0 filesrc location="<path-to-wav-audio-file>" ! wavparse ! audioconvert ! alsasink device=hw:0
```
* play audio file RAW format:
```shell
$ gst-launch-1.0 -e filesrc location = "<path-to-raw-audio-file>" \
! rawaudioparse use-sink-caps=false format=pcm pcm-format=s16le sample-rate=16000 num-channels=1 \
! audioconvert \
! audioresample \
! alsasink device=hw:0
```
