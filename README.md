# REPO FOR AWESOME TECHY TECHY STUFF

This is just a place where I put things that I often use for work and play.

## .bashrc and .vimrc
just useful stuff to both, either append them or add them with source

## Windows
in my current role I have to use windows so all my Linux magic happens on a VM, here's how I set everything up
1. Install hyper-v if you don't already have it
2. Download your prefered linux distro, I use Ubuntu server
3. Setup your instance via hyper-v
3. Hyper-v doesn't automatically give the IP of Linux instance because... reasons? `¯\_(ツ)_/`  Whatever the reason the instructions to see the IP are here
  * run this in the terminal
    * `sudo apt-get install "linux-cloud-tools-$(uname -r)"`
    * you may have to play around with this a bit, install some other stuff and/or restart your machine
  * Congratulations now you can get the IP and ssh in
4. Next you'll need to mount a shared directory (directory!!!! Not folder, we're engineers not users)
  1. this URL covers the windows side far better than I can
    * https://linuxhint.com/shared_folders_hypver-v_ubuntu_guest/
    * You can ignore the Linux step, that's in step 2
  2. add this to your bashrc
    * `alias msha="sudo mount -t cifs //<computer name>/<path to shared directory> ~/shared -o user=$(whoami),uid=$UID,gid=$(getent group $(whoami) | cut -d ':' -f3)"`
  3. restart your bash and msha should automatically mount the directory
    * You'll probably notice that everything has execute, not sure why that is the case yet or how to fix it