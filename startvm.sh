#!/bin/bash

LC_ALL=C \
PATH=/usr/local/sbin:/usr/local/bin:/usr/bin \
USER=root \
HOME=/home/nick/QemuHDADump/domain--1-win11 \
XDG_DATA_HOME=/home/nick/QemuHDADump/domain--1-win11/.local/share \
XDG_CACHE_HOME=/home/nick/QemuHDADump/domain--1-win11/.cache \
XDG_CONFIG_HOME=/home/nick/QemuHDADump/domain--1-win11/.config \
/home/nick/qemu/build/qemu-system-x86_64 \
-name guest=win11,debug-threads=on \
-object '{"qom-type":"secret","id":"masterKey0","format":"raw","file":"/home/nick/QemuHDADump/domain--1-win11/master-key.aes"}' \
-blockdev '{"driver":"file","filename":"/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}' \
-blockdev '{"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","file":"libvirt-pflash0-storage"}' \
-blockdev '{"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/win11_VARS.fd","node-name":"libvirt-pflash1-storage","read-only":false}' \
-machine pc-q35-9.0,usb=off,vmport=off,smm=on,dump-guest-core=off,memory-backend=pc.ram,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-storage,hpet=off,acpi=on \
-accel kvm \
-cpu host,migratable=on,hv-time=on,hv-relaxed=on,hv-vapic=on,hv-spinlocks=0x1fff,hv-vendor-id=KVMKVMKVM \
-global driver=cfi.pflash01,property=secure,value=on \
-m size=8388608k \
-object '{"qom-type":"memory-backend-ram","id":"pc.ram","size":8589934592}' \
-overcommit mem-lock=off \
-smp 4,sockets=4,cores=1,threads=1 \
-uuid e8b58882-152b-4274-aed4-0b6970c0eaa9 \
-rtc base=localtime,driftfix=slew \
-global kvm-pit.lost_tick_policy=delay \
-global ICH9-LPC.disable_s3=1 \
-global ICH9-LPC.disable_s4=1 \
-boot menu=on,strict=on \
-blockdev '{"driver":"file","filename":"/var/lib/libvirt/images/win11.qcow2","node-name":"libvirt-3-storage","auto-read-only":true,"discard":"unmap"}' \
-blockdev '{"node-name":"libvirt-3-format","read-only":false,"discard":"unmap","driver":"qcow2","file":"libvirt-3-storage"}' \
-device '{"driver":"ide-hd","bus":"ide.0","drive":"libvirt-3-format","id":"sata0-0-0","bootindex":1}' \
-blockdev '{"driver":"file","filename":"/home/nick/Downloads/Win11_23H2_English_x64v2.iso","node-name":"libvirt-2-storage","read-only":true}' \
-device '{"driver":"ide-cd","bus":"ide.1","drive":"libvirt-2-storage","id":"sata0-0-1","bootindex":2}' \
-blockdev '{"driver":"file","filename":"/home/nick/Downloads/virtio-win-0.1.240.iso","node-name":"libvirt-1-storage","read-only":true}' \
-device '{"driver":"ide-cd","bus":"ide.2","drive":"libvirt-1-storage","id":"sata0-0-2"}' \
-global ICH9-LPC.noreboot=off \
-watchdog-action reset \
-device vfio-pci,host=0000:00:1f.0,multifunction=on,x-no-mmap=true,bus=pcie.0,addr=10.0 \
-device vfio-pci,host=0000:00:1f.3,multifunction=on,x-no-mmap=true,bus=pcie.0,addr=10.3 \
-device vfio-pci,host=0000:00:1f.4,multifunction=on,x-no-mmap=true,bus=pcie.0,addr=10.4 \
-device vfio-pci,host=0000:00:1f.5,multifunction=on,x-no-mmap=true,bus=pcie.0,addr=10.5 \
-sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny \
-msg timestamp=on \
-monitor stdio

