#!/bin/bash
newid=198
memory=2048
bridge=vmbr1
imgstorage=local
vm_name=clone

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

url_hirsute=https://cloud-images.ubuntu.com/hirsute/current/hirsute-server-cloudimg-amd64.img
name_hirsute=hirsute-server-cloudimg-amd64.img

# test for required packages for image manipulation
package_missing=1
test $(dpkg-query -W -f='${Status}' libguestfs-tools 2>/dev/null | grep -c "ok installed") -eq 0 && package_missing=0

# install tools for image manipulation (virt-customize)
test $package_missing -eq 0 && echo "Install image customization packages?"
yes | apt-get install --quiet --assume-yes libguestfs-tools

echo "[${green} OK ${reset}] All packages installed!"

url=$url_hirsute
name=$name_hirsute

# download the image
echo "${green} Downloading base image.${reset}"
wget $url -q --show-progress | bash

# test successful download
test ! -f ./$name && echo "[${green} OK ${reset}] Download successful!" >&2 && exit 1

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
test $? -eq 0 && echo "[${green} OK ${reset}] Setting networking configuration in VM."

# import the downloaded disk to local storage
qm importdisk $newid $name $imgstorage -format qcow2
test $? -eq 0 && echo "[${green} OK ${reset}] Setting image format to qcow2."

# attach the new disk to the VM as scsi drive
qm set $newid --scsihw virtio-scsi-pci --scsi0 /var/lib/vz/images/$newid/vm-$newid-disk-0.qcow2
test $? -eq 0 && echo "[${green} OK ${reset}] Attach the new disk to the VM as a scsi drive."

# configure CD-ROM drive to pass cloud-init data to image
qm set $newid --ide2 $imgstorage:cloudinit
test $? -eq 0 && echo "[${green} OK ${reset}] Configured a CD-ROM drive to pass cloud-init data to image."

# set boot order
qm set $newid --boot c --bootdisk scsi0
test $? -eq 0 && echo "[${green} OK ${reset}] Set a new boot order."

# configure serial console to use as a display (a possible requirement for OpenStack images)
qm set $newid --serial0 socket --vga serial0
test $? -eq 0 && echo "[${green} OK ${reset}] Configured serial console as a display."

# set a new name
qm set $newid --name $vm_name
test $? -eq 0 && echo "[${green} OK ${reset}] New VM name set to clone."

# converting to a template
qm template $newid
test $? -eq 0 && echo "[${green} OK ${reset}] Converted image to a template."

# remove downloaded image
rm $name
test $? -eq 0 && echo "[${green} OK ${reset}] Removed downloaded .img file."

exit 0;