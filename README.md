# Windows mstsc.exe RDP Connection with Window Size in Filename

Brendan Kidwell  
13 May 2020

https://github.com/bkidwell/rdp-sized

## Introduction

On Windows, I want an RDP client with the following features:

* Let me set the terminal window size to cover most of my primary display (not counting the client titlebar and my taskbar).
* Each connection is its own separate window.
* Scale some connections to 125%. (With my eyes and my current computer I can't use "100%" scaling on this display. Some servers I connect to refuse to let me resize on the remote end.)

I've tried the `mstsc.exe` built into Windows, and I've tried some alternative clients. `mstsc.exe` gets me most of the way there, but I just need a way to easily set a client window size in the connection `.rdp` file and make it stick; it's easy to lose a custom window size if you use `mstsc.exe`'s graphical connection editor.

My solution is a couple of Windows `.cmd` batch scripts that wrap `mstsc.exe` and provide appropriate command line parameters for the behavior I want.

## How the Scripts work

Let's assume you have a 1920×1080 display, about 15 inches, and you want to use Windows "125%" scaling. You probably have a taskbar set at a certain size, and you want all the *remaining* desktop area to be taken by the RDP client windows.

There are two scenarios, depending on the server environment:

* Server allows you to set "DPI" or "scaling" on the remote end
  * Client window with titlebar should be 1900×1000 pixels.
  * Set "125%" scaling or "120 dpi" on the server.
* Server does not allow you to set "DPI" or "scaling" on the remote end
  * Client window with titlebar should be 1520×800 pixels.
  * After connecting, right-click on client titlebar and set client-side scaling to 125%.

`rdp-sized.cmd` in this package reads the client window **height** from the **filename** of the connection file being launched, and automatically sets the **width** to match -- based on an if/else tree. It passes the appropriate parameters into Windows own `mstsc.exe` RDP client.

`rdp-edit.cmd` is a quick workaround to make it easy to *edit* an `.rdp` file in `mstsc.exe` after you've changed the desktop config to specify that `rdp-sized.cmd` is the default handler for `.rdp` files.

## Installing

### 1. Copy Scripts to a Program Folder

You might already have a personal `bin` or `scripts` folder with little utilities which is listed in your Windows `%PATH%` environment variable. If so, copy `rdp-sized.cmd` and `rdp-edit.cmd` there. Otherwise, create a `%USERPROFILE%\scripts` folder, put the two scripts in there, and [add that folder to your `%PATH%` environment variable](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/) now.

### 2. Install into Windows Desktop Environment

You'll want `rdp-sized.cmd` to be your default handler for `.rdp` files. To that, find or create an `.rdp` file now, right-click on it, select "Open with → Choose another app". Navigate to and select `rdp-sized.cmd` as the target, and make sure you mark "Always use this app for .rdp files", then click "OK". You can terminate the RDP client connection that gets launched now, and proceed to the next step.

Now that you've changed the default handler for `.rdp`, there isn't a convenient way to launch an `.rdp` file in `mstsc.exe` in Edit mode. To fix that, open up your "SendTo" folder. Click Start → Run, and execute the command `shell:sendto`. Create shortcuts here for `rdp-sized.cmd` and `rdp-edit.cmd`.

Editing the SendTo menu like this is a global operation for your login profile -- the two scripts' shortcuts will appear in SendTo for ALL file types. There are cleaner ways of doing the installation, but they are beyond the scope of this quick guide.

### 3. Configuring Client Window Sizes

Finally, you're ready to configure your client window sizes.

Remember, the `.rdp` file's **filename** specifies the window height. This is matched to a desired width in `rdp-sized.cmd`, and passed into `mstsc.exe` as a command line parameter, and it will override any client window size that was set the last time you edited and re-saved the file using `mstsc.exe`.

To change the permanent window size preference for an `.rdp` file:

1. Decide on the window dimensions you want, either by measuring or trial and error while you repeat the rest of these steps.
2. Name the `.rdp` file like `foo--HEIGHT.rdp`, where `HEIGHT` is an integer number of pixels. There must be two hyphens ("--") preceding the `HEIGHT` number.
3. Edit `rdp-sized.cmd`, lines 30 through 33. Change the series of if-else statements there and make sure every **height** you would use in a filename has a corresponding **width** in this block of code.
4. Launch the `.rdp` file with `rdp-sized.cmd` and see if it came out to the right fit. Re-edit the filename and the script until you get it right.

Don't forget that the scripts here can't set the client-side **scaling** for the RDP connection, in the case where you aren't allowed to set it on the server end! Each time after you launch the `.rdp` file, if you don't want to use "100%" scaling, you need to right-click the client titlebar and set the scaling to the your desired value.
