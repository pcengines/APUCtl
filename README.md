# APUCtl

PC Engines APU tool to control your hardware from the command line. Like wifi on/off hardware switch and your simcard slot selection.

## Info

apuctl v1.01 2022 (c) MonkeyCat ([code.monkeycat.nl](https://code.monkeycat.nl))

## See also

[APUFirmware](https://github.com/Monkeycat-nl/APUFirmware) an easy PC Engines APU firmware auto downloader and updater.

## Usage

```
usage: apuctl command

 status         show status of the wifi and the simcard slot
 on             enable  mPCIe wifi transmission
 off            disable mPCIe wifi transmission
 one-on         enable  mPCIe2 wifi transmission
 one-off        disable mPCIe2 wifi transmission
 two-on         enable  mPCIe3 wifi transmission
 two-off        disable mPCIe3 wifi transmission
 sim-one        select simcard one
 sim-two        select simcard two
 one-reset      reset mPCIe2
 two-reset      reset mPCIe3
 coldboot       cold reboot
```

## Practical

When you run `apuctl off`, it disables the hardware radio of the wifi cards in both internal slots (if present).

When you run `apuctl sim-two` it will select the second simcard slot.

## Typical output

```
apuctl v1.01 2022 (c) MonkeyCat (code.monkeycat.nl)

simcard slot two is selected
wifi mPCIe2 on
wifi mPCIe3 on
```

## Errors

It return a non zero error code when failed, see the source what's what.

## Notes

Some (debian) system you have no access to the gpio stuff wether you are root or not. And don't bother with `one-reset` `two-reset` or `coldboot` if you don't know what you are doing.

## Sources

 * [cold reset](https://pcengines.github.io/apu2-documentation/cold_reset/)
 * [gpio](https://pcengines.github.io/apu2-documentation/gpios/)
