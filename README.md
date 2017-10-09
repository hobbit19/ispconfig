# ISPConfig Automation

This script automates a "The Perfect Server - Ubuntu 16.04" with Nginx, MariaDB, PHP7, Postfix, BIND, Dovecot, Pure-FTPD and ISPConfig 3.1.

Made just like explained in the link below. Use it to know what to answer in the prompts:
https://www.howtoforge.com/tutorial/perfect-server-ubuntu-with-nginx-and-ispconfig-3

Tested on: 
- Linode VPS

## How to use

> **Important!** First of all, see the steps 1 and 2 on the tutorial for preliminary setup.

1) Clone this repository on some folder like "/tmp".

```
cd /tmp
git clone https://github.com/marcelobdsilva/ispconfig.git
cd ./ispconfig  
```

2) Add execution permision to "install.sh" file
```
chmod +x ./install.sh
```

3) Execute the installation
> **Important!** Answer the prompt messages on the screen exactly like explained on the tutorial. Except about the passwords, you can define the passwords on the prompt instead of just press Enter.
```
./install.sh
```

## Additional Notes
After complete installation, you can access your server like this:
> Use the passwords you have been defined on prompt screens
- ISPConfig Panel: https://YOUR_IP:8080
- RoundCube: http://YOUR_IP:8081/webmail
- PhpMyAdmin: http://YOUR_IP:8081/phpmyadmin (default user is "phpmyadmin")