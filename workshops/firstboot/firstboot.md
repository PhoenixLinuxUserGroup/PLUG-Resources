# Living With Linux 0: First Boot
Hello and welcome to the first event in the Living With Linux series and the first PLUG event of the year! This series will introduce you to Linux as a desktop OS and get you started on Linux.
>[!Note]
>Please make sure you have read through the [readme](readme.md) announced earlier today and have chosen a Linux distro. This document contains all you need to have downloaded and ready to follow along with this event.
## What Is Linux?
When we refer to Linux in this case, we're referring to an operating system that uses the Linux kernel at its core and allows you to interface with it. In its most basic form, this kernel is responsible for controlling system processes and interfacing them with your computer's hardware.
There are *thousands* of operating systems that meet that description, called distros. From the [pre-lab readme](readme.md), you may recall that no distros are created equal, and many are optimized for different things. In this case, you have chosen a distro that meets your needs and will be installing it during this event.
What we are doing today is the tip of the iceberg for Linux. Linux can be used for all sorts of things, from being your desktop OS, to running [63% of the world's servers](https://www.fortunebusinessinsights.com/server-operating-system-market-106601) and even showing up on embedded hardware. This is to say, you may have used Linux without even knowing it.
## Running in VirtualBox
With VirtualBox, you'll be able to try Linux without messing with your computer too much. VirtualBox allows you to run a virtual machine on your Linux machine.
1. To get started, click the `New` button.
![](resources/vbox1.png)
2. Now name your VM, select your ISO file.
3. If the name or .iso you give it does not fill out the `OS`, `OS Distribution`, and `OS version fields`, please select them manually to the best of your knowledge. This allows Virtualbox to set up your distro to a recommended preset.
4. Choose whether to use Unattended Installation, an option that allows it to install your OS for you. Many distros don't support it. If you choose unattended installation, click on `Set up unattended guest os installation` and fill out the form.
![](resources/vbox2.png)
5. Click on `Specify virtual hardware`. In most cases the preset VirtualBox gives you is the bare minimum, so you may need to increase RAM and CPU core count accordingly. Additionally, you can specify if you need your VM to work with UEFI instead of a traditional BIOS.
![](resources/vbox3.png)
6. Finally, choose your VM's hard disk size under `Specify virtual hard disk` and click `Finish` when done. Additionally, if you'd like to place your VM somewhere else you can choose the save location here.
![](resources/vbox4.png)
7. Finally, click `Start` to run your VM!
![](resources/vbox5.png)
## Running in MacOS under UTM
UTM lets you try Linux distros on a Mac and can both virtualize the OS and emulate OSes under different CPU architectures. Here is how you can set it up.
>[!TIP]
>As stated [previously](readme.md), make sure to download the `aarch64` or `arm64` builds of your chosen distro if available and if you're running an Apple Silicon Mac. This allows you to virtualize your distro, allowing it to basically run as fast as your computer does.

1. After downlading the `.dmg` file, mount it and move the UTM app to your Applications folder.
2. Open UTM and select `Create New Virtual Machine`
![](resources/utm1.png)
3. Select `Virtualize`
![](resources/utm2.png)
4. Select `Linux`
![](resources/utm3.png)
5. Select how much RAM and CPU cores you'd like to allocate for the VM and click `Continue`. We recommend choosing values in line with your distro's minimum system requirements. Here, you can also select 3D acceleration as well.
![](resources/utm4.png)
6. Now choose your `.iso` image and click `Continue` after choosing.
![](resources/utm5.png)
7. Choose how much storage space you wish to allocate then click `Continue`.
![](resources/utm6.png)
8. You also have the option to share a folder with your VM. Choose a path if you would like to do this then click `Continue` when done.
9. It will give you a summary of what you set up. Check it over and make sure it's what you need and click `Save`.
![](resources/utm7.png)
10. Now press any of the play buttons for your VM. A new window will open and your VM will boot. You will now be able to try out Linux on your Mac.
![](resources/utm8.png)
![wake up babe linux 2 dropped](resources/utm9.png)
>[!NOTE]
>This process is the same if you choose to emulate your OS, however you will select `Emulate` rather than `Virtualize`. Additionally, you may notice that you get more options on step 5, allowing you to choose what CPU architecture you'd like to emulate. The default option, `Intel ICH9 based PC (2009)` is the correct option, as it correlates to all PC based Linux distros.
## Installing on real hardware
If you're installing on your actual computer instead of a VM, you'll need to to do a couple of things differently. Since we can't boot directly off of our `.iso` file, we'll need to put it on a flash drive. Additionally, even if we just move the `.iso` to the flash drive, we still won't be able to boot off it. So we will need to make it bootable by flashing it. To do this, there are a couple programs available that can do this:
>[!CAUTION]
>This procedure will wipe your entire flash drive and replace it with your Linux distro. If you have important files on it, back them up first.
### Flashing using balenaEtcher
Etcher is a flashing program available for all platorms (Windows, Mac and Linux) that easily allows you to create your flash drive. 
![Etcher](resources/etcher.png)
To flash to your drive using Etcher, simply open it, select your `.iso`, select your flash drive and click `Flash`.
It will take a few minutes to get your file onto the drive and validate it. When it's done, you're ready to go!
### Flashing using Rufus
Rufus is a similar program, but it is only available on Windows. It has a similar UI to the Windows disk formatting utility, and gives you more options than Etcher.
To flash using Rufus, download and open it. It will ask you if you would like to update, and may also ask if you would like to update `DBX` files. Choose an option to continue.
![Rufus](resources/rufus.png)
Once we're past that, select your device and '.iso' file. Press start and wait for it to finish. Similar to etcher, when it's done, you're ready to go!
### Booting
To boot off of your flash drive, reboot your computer. When it shuts down, spam your computer's boot menu key (usually `F9`). You'll then be presented with the boot menu, from which you'll select your flash drive. It will most likely be the option with your distro's name.
>[!TIP]
>If your computer doesn't let you select your OS using the mouse, use the arrow keys and hit `Enter` to select.

Once you select your distro, it will begin to boot.
>[!NOTE]
>If your distro fails to boot, you may need to disable Secure Boot or enroll your distro's Platform Key. See [this guide](https://gadgetsfeed.com/how-to-enroll-platform-key-in-bios/) to learn how to enroll a Platform Key.
## The Anatomy of a standard Linux install
This section will demonstrate how the average Linux install goes. Here, we'll be installing Mint, since it is a good representation of the average Linux installation. So here's what you'll see when you boot into Linux for the first time:
### 1. The boot menu
Your distro comes with a boot menu, powered by GNU GRUB. If you're dual booting, expect to see this menu everytime you start your computer, as it will be used to switch you between Linux and Windows. You can interact with this menu using the arrow keys and `Enter` key. It will automatically skip and choose the default option if you do nothing in 5-10 seconds.
![GRUB my beloved](resources/boot.png)
### 2. Boot screens and verbose mode
This is the most unremarkable part of the boot sequence. Depending on your distro, it will either be your distro's logo or something completely new and different: verbose mode. Here on Mint, the ISO file boots using verbose mode. Verbose mode allows you to find out if your distro is having trouble booting, because it tells you what it's trying to do that's getting it stuck. If everything is going well, a ton of text should fly by quickly.
![Verbose mode](resources/verbose.png)
>[!TIP]
>If your distro shows a proper boot screen, and you want to see verbose mode, you can press `Esc` to toggle between the boot screen and the verbose mode log.
### 3. The desktop
Now that that's done, we get access to the full desktop. Here, you have free reign over the distro and get to try it before installing it to your computer. Since we're installing this OS, we'll click on the `Install Linux Mint` on our desktop.
>[!Caution]
>Any data at this stage doesn't get saved, as the OS is running of your computer's RAM.

>[!NOTE]
>Not all distros take you straight to the desktop. Ubuntu, for example presents you with the language, keyboard and internet setup menus before giving you the choice to try the distro.

![The desktop](resources/desktop.png)
### 4. The installer
Now we get to the fun part, and get to install Linux! The installer will ask a bunch of questions and get you through the process. In this case, the process is as follows:
1. Choose a language. On Mint, they just list languages on the menu on the left side. Select one and click continue.
![Select your language](resources/language.png)
2. Choose a keyboard layout. The left menu allows you to select your keyboard's language and the right menu is your specific layout. You also get a space to test out you keyboard with. If you're uncertain about your exact layout, you can have it detect it automatically by clicking `Detect Keyboard Layout`. It will ask you to press keys to determine keyboard layout and ask if you have certain keys on your keyboard. When you're done, click `Continue`
![Keyboard layouts](resources/keyboard.png)
3. Decide if you want multimedia codecs. Since they may not be able to bundle multimedia codecs with the OS, they give you the option to install them. Check the box if you need these codecs and click `Continue`.
![Codecs](resources/codecs.png)
4. Format and repartition your HDD/SSD. This is basically the point of no return when installing Linux. In this example, we're using a VM with an empty drive. Thus, we only can choose between erasing it completely or something else (which will let us choose how much storage space you want it to take up). Had we had another OS on there, it would also give us the option to set up dual booting, and may let us set up how much space Linux should take up.
![Deleting drives](resources/drives.png)
>[!CAUTION]
>As your OS will tell you, any data on your drive will be deleted, especially if you've chosen to completely replace your OS with Linux. Please ensure that you've backed up all of your important data before proceeding.

Once you're ready to go, click `Install Now`. You'll then get the following message, asking you to confirm you are fine with having your hard drive wiped so you can install Linux:
![Confirmation](resources/confirmation.png)
Click `Continue` if you're cool with the changes it is about to make. Linux will then be installed.
5. Choose your time zone. While it's installing, it will guide you through setting up your system.
6. Create your user acocunt/password. Fill out the form to set up your account. This account is local to your computer only. Additionally, you can choose to have it log you in automatically, so you can get to your desktop faster. You will still need to remember your password when installing apps.
>[!TIP]
>The username and computer name will be automatically filled when you type in your name. If you're fine with the default names, you can simply click `Continue`.

7. Installation time! It will start installing Linux on your freshly wiped hard drive. This will take a while, depending on your hardware. Once done, it'll let you know.

![Installation](resources/installation.png)

### 5. Finishing installs
When installation finishes, it will prompt you to reboot. Choose `Restart Now` to continue.
![Reboot](resources/reboot.png)
It will then tell you to remove your install media (i.e. your flash drive) and hit `Enter`. If you're doing this on a VM, simply hit `Enter`. Your VM app will eject the ISO for you.
![Final Reboot message](resources/finalreboot.png)

### 6. Welcome to Linux!
When you're finished, you'll get a login screen. Type in your password and hit enter. You'll be sent straight to your new desktop!
![Login](resources/login.png)
You may even see a welcome program show up, depending on your distro. It will give you a tour of the desktop and allow you to customize your experience.
![Welcome](resources/welcome.png)

## Conclusion
With that being said, you're now officially a Linux user! In the coming weeks, we'll be going over what you can do with this OS and how you can accomplish certain daily tasks on Linux. In future episodes of Living With Linux, we'll go over how you can run Windows apps and games on Linux, so stick around for more!