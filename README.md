# hda-tools

This repo contains some tools I used to get audio working with linux for a Samsung Galaxy Book 3 Pro 360
using the ALC298 chip.  The basic idea is to get windows running in a vm to snoop what data it sends to
the audio codec so that the same data can be applied when running linux.

-- Getting a VM setup

Used virtual machine manager to set up a new vm with secure boot and TPM enabled.  After getting windows
installed, install Samsung Update from the windows store, and install the audio driver.  Now run the
custom version of qemu https://github.com/hamfirst/qemu-corb-snoop with VFIO passthrough for the sound
device.  The file startvm.sh can be used as an example

-- Using the verbs

Qemu should produce a file called corbs.txt which contains all the hda processing coefficient writes
perfomed by the vm.  This file can be run as a shell script.  Typically corbs.txt will contain the init
and cleanup verbs, so it might be necessary to run the script while sound is playing to determine
exactly where sound starts working.

-- Processing verbs

In order to understand what's happening in corbs.txt, you can run analyzeverbs.py on the corbs.txt file.
This produces a simplified output that is more suitable for generating a kernel patch
