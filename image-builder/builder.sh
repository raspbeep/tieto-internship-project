#!/bin/bash
newid=198
cloneid=269
memory=2048
# LXC router
bridge=vmbr1
imgstorage=local
vm_name=clone

# TODO: Solve: "virt-customize: warning: random seed could not be set for this type of guest"

url_hirsute=https://cloud-images.ubuntu.com/hirsute/current/hirsute-server-cloudimg-amd64.img
name_hirsute=hirsute-server-cloudimg-amd64.img

url_focal=https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
name_focal=focal-server-cloudimg-amd64.img

url_bionic=https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
name_bionic=bionic-server-cloudimg-amd64.img

# test for required packages for image manipulation
package_missing=1
test $(dpkg-query -W -f='${Status}' libguestfs-tools 2>/dev/null | grep -c "ok installed") -eq 0 && package_missing=0

# install tools for image manipulation (virt-customize)
test $package_missing -eq 0 && echo "Install image customization packages?"
yes | apt-get install --quiet --assume-yes libguestfs-tools

printf "%s\n%s\n%s\n%s\n" "Choose an image:" "  (1) 21.04 Hirsute(latest)" "  (2) 20.04 Focal(latest)" "  (3) 18.04 Bionic(latest)"
printf "%s" "Image to download: "
read var

case $var in 
    1)
        url=$url_hirsute
        name=$name_hirsute
        echo "Hirsute image set."
        ;;

    2)
        url=$url_focal
        name=$name_focal
        echo "Focal image set."
        ;;
    
    3)
        url=$url_bionic
        name=$name_bionic
        echo "Bionic image set."
        ;;
    
    *)
    echo -n "unknown"
    ;;
esac

# download the image
wget $url -q --show-progress | bash

# test successful download
test ! -f ./$name && echo 'Download unsuccessful.' >&2 && exit 1

# add gpg key
virt-customize -a $name --run-command 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -'

# add docker repository
virt-customize -a $name --run-command 'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"'

# update and upgrade packages
virt-customize -a $name --update 

# install packages required on each VM
virt-customize -a $name --install qemu-guest-agent,docker-ce,apt-transport-https,ca-certificates,curl,software-properties-common

# enable remote root login with an ssh key
virt-customize -a $name --run-command "sed -i 's/.*#PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config"

# disable deafult nginx start on boot
virt-customize -a $name --run-command "sudo systemctl disable nginx"

# create a new virtual machine in Proxmox 
qm create $newid --memory $memory --net0 virtio,bridge=$bridge

# import the downloaded disk to local storage
qm importdisk $newid $name $imgstorage -format qcow2

# attach the new disk to the VM as scsi drive
qm set $newid --scsihw virtio-scsi-pci --scsi0 /var/lib/vz/images/$newid/vm-$newid-disk-0.qcow2

# configure CD-ROM drive to pass cloud-init data to image
qm set $newid --ide2 $imgstorage:cloudinit

# set boot order
qm set $newid --boot c --bootdisk scsi0

# configure serial console to use as a display (a possible requirement for OpenStack images)
qm set $newid --serial0 socket --vga serial0

# set a new name
qm set $newid --name $vm_name

# converting to a template
qm template $newid

# remove downloaded image
rm $name