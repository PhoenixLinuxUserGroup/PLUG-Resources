# Basics of Bash Scripting

## Introduction
Most of our interactions with our chosen Operating System (OS) happen within either a desktop environment or terminal. As Linux users, it helps to become familiar with become familiar with the terminal and its underlying machinery. The terminal itself is an environment for the **shell**, the real workhorse, to do its job. Linux has a variety of shells available for use, but the default on most distributions is the Bourne Again SHell (BASH, or bash). One of the advantages of shells is your ability to create user scripts. Whether it be to automate updates, backup files, or launch your favorite apps on startup, this can all be accomplished with shell scripts. 

This workshop will go over the basics of shell scripting, as well as provide some examples of how we use shell scripts to automate tasks for server-side administration. 

## SCRIPT 1: Hello, World!
Let's start with a simple example. 
```bash
### hello.sh ###
#!/bin/bash
echo "Hello world!"
```
A classic test for any beginner is printing something to the console! In a shell script, we have access to any command-line tool we would normally think about in the terminal. In this case, we can use `echo` to print our message to the console. Important to note, we always begin our shell scripts with `#!/bin/bash` to specify to our interpreter we want to run this program with bash. If we were using a different shell, such as `zsh`, this specifies that we want bash in particular to execute our script. 

One last thing to do before we can run this script is grant it permission to execute. In Linux, all files have three types of permissions: read, write, and execute. Depending on your distribution or kernel configuration, new files typically only have read and write permissions. We can view these by using either `stat`for a singular file
```bash
$ stat hello.sh
  File: hello.sh
  Size: 33              Blocks: 8          IO Block: 4096   regular file
Device: 259,6   Inode: 20598471    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2025-09-22 14:34:10.340633459 -0400
Modify: 2025-09-22 14:34:10.340633459 -0400
Change: 2025-09-22 14:34:10.340633459 -0400
 Birth: 2025-09-22 14:34:10.340633459 -0400
```
or `ls -l` for all files in a directory
```bash
$ ls -l 
total 8
-rw-r--r-- 1 root            root              33 Sep 22 14:34 hello.sh
-rw-rw-r-- 1 midnightmoniker midnightmoniker 1006 Sep 22 14:19 scriptingworkshop.md
```

We can change file permissions with `chmod` and run our program. 
```bash
$ sudo chmod a+x hello.sh # OR sudo chmod 755 hello.sh
$ ./hello.sh
Hello, world!
```

## SCRIPT 2: Variables, Strings, and Control
```bash
### food.sh ###
#!/bin/bash
food=$1

echo "My favorite food is $food!"
echo 'But my favorite variable is $food'

if [[ "$food" == "pizza" || "$food" == "pie"]]; then
    echo "$food has delicious crust!"
fi
```
Bash has many features typical of a programming language, including logical operators, conditional statements, and variables. We can assign a variable in a bash script using the format `foo=bar`. Important to note, you need to have no space when assigning variables to have these values interpreted correctly. In our script, we specifically assign the value `$1` to food. `$1` represents the first argument given to our shell script, with `$0` being the name of the script itself. If you haven't picked up already, we can reference the value of a string by using the `$` operator before it's name. 

In the second part of our script, we echo the name of the food we entered. Bash will interpret strings using single and double quotations differently. Single quotations are pure literals, and any variable marks are ignored. Double quotes will interpret any variables marks we give it. 

Finally, we can see a basic use of an `if` statement in bash. If statements begin with a condition, marked by double brackets. We can use OR, AND, and NOT operators with `&&`, `||`, and `!` respectively. In this case, we compare our entered argument and print a bonus message if the argument is 'pizza' or 'pie'

```bash
$ ./food.sh
But my favorite variable is $food
pizza has delicious crust!
```

## SCRIPT 3: Automating Updates
```bash
### update.sh ### 
#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove
sudo apt clean
echo 'System upgrades successful!'
```
Let's get into some practical examples. For the sake of ease, we will be assuming you have installed a Debian/apt based distro. This first script will update and upgrade a Debian/apt based distro. We call `sudo` along with a couple of `apt` commands to:
* Refresh the `apt` repo
* Upgrade packages that are available
* Autoremove old and unneeded packages
* Clean the download cache
* Print a message to the console to show success

```bash
$ ./update.sh
Get:1 http://deb.debian.org/debian testing InRelease [147 kB]
Hit:2 http://security.debian.org/debian-security testing-security InRelease
Get:3 http://deb.debian.org/debian testing/main i386 Packages.diff/Index [63.6 kB]
Get:4 http://deb.debian.org/debian testing/main amd64 Packages.diff/Index [63.6 kB]
Get:5 http://deb.debian.org/debian testing/main i386 Packages T-2025-09-23-2006.53-F-2025-09-23-2006.53.pdiff [1,910 B]
Get:5 http://deb.debian.org/debian testing/main i386 Packages T-2025-09-23-2006.53-F-2025-09-23-2006.53.pdiff [1,910 B]
Get:6 http://deb.debian.org/debian testing/main amd64 Packages T-2025-09-23-2006.53-F-2025-09-23-2006.53.pdiff [291 B]
Get:6 http://deb.debian.org/debian testing/main amd64 Packages T-2025-09-23-2006.53-F-2025-09-23-2006.53.pdiff [291 B]
Fetched 277 kB in 1s (199 kB/s)                     
All packages are up to date.    
The following packages were automatically installed and are no longer required:
  libx264-164  libx264-164:i386
Use 'sudo apt autoremove' to remove them.

Summary:
  Upgrading: 0, Installing: 0, Removing: 0, Not Upgrading: 0
REMOVING:                       
  libx264-164  libx264-164:i386

Summary:
  Upgrading: 0, Installing: 0, Removing: 2, Not Upgrading: 0
  Freed space: 5,735 kB

Continue? [Y/n] y
(Reading database ... 253891 files and directories currently installed.)
Removing libx264-164:amd64 (2:0.164.3108+git31e19f9-3) ...
Removing libx264-164:i386 (2:0.164.3108+git31e19f9-3) ...
Processing triggers for libc-bin (2.41-12) ...
System upgrades successful!
```

## SCRIPT 4: Automating System Backups
```bash
### backup.sh ###
#!/bin/bash

# Main function for performing a backup
backup () {
  sudo timeshift --create --comments "Backup created with backup.sh: $(date)" --tags O
}

# Check if Timeshift is installed. If not, warn the user and prompt to download. 
if [ "$(dpkg -l | awk '/timeshift/ {print }'|wc -l)" -ge 1 ]; then
  backup
else
  echo WARNING: This script depends on Timeshift. 
  read -p "Install now?" -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$]]
  then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
  else
    sudo apt install timeshift
    backup
fi
```

This script will create an on-demand backup for your system. This system relies on a package called Timeshift. This script specifically checks if timeshift is installed before executing. If not, it will ask you to install it. 