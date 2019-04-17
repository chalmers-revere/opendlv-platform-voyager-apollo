#!/bin/bash

echo Root password?
read root_password

echo Revere user password?
read user_password

hdd=/dev/nvme0n1p1

wget https://raw.github.com/chalmers-revere/opendlv.os/master/x86/get.sh
sh get.sh

cp setup-available/setup-post-05-docker.sh \
   setup-available/setup-post-08-serialconsole.sh \
   setup-available/setup-post-09-socketcan.sh \
   .

sed_arg="s/hostname=.*/hostname=voyager-apollo-x86_64-1/; \
    s/root_password=.*/root_password=${root_password}/; \
    s/user_password=.*/user_password=( ${user_password} )/; \
    s/lan_dev=.*/lan_dev=eno2/; \
    s%hdd=.*%hdd=${hdd}%; 
sed -i "$sed_arg" install-conf.sh

#sed_arg="s/dev=.*/dev=( can0 can1 can2 can3 )/; \
#         s/bitrate=.*/bitrate=( 500000 500000 500000 500000 )/"
#sed -i "$sed_arg" setup-post-09-socketcan.sh

# for the Nvidia
#sed_arg='/pacman -S --noconfirm nvidia/d'
#sed -i "$sed_arg" setup-chroot-01-rtkernel.sh

#sed_arg="s/-j4/-j\$(nproc)/g"
#sed -i "$sed_arg" setup-chroot-01-rtkernel.sh

#sed -i '/-j\$(nproc)/a make modules_install' setup-chroot-01-rtkernel.sh

#sed -i "\$aif [[ \$(lspci | grep VGA | grep NVIDIA) ]]; then" setup-chroot-01-rtkernel.sh
#sed -i "\$a\ \ pacman -S --noconfirm nvidia-dkms" setup-chroot-01-rtkernel.sh
#sed -i "\$a\ \ dkms autoinstall" setup-chroot-01-rtkernel.sh
#sed -i "\$afi" setup-chroot-01-rtkernel.sh
chmod +x *.sh

./install.sh 
