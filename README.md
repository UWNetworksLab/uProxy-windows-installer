# uProxy Windows Installer

uProxy is a browser plugin that allows users to reach the open internet through a trusted friend or uProxy cloud server.

The uProxy Windows Installer creates a modified version of the Firefox Windows Installer with the uProxy extension enabled by default. This allows Windows users to get up and running with uProxy quickly.

###Dev setup:
- Need to use a Windows OS
- [7-zip](http://www.7-zip.org/) and [signtool](https://www.microsoft.com/en-us/download/details.aspx?id=8279), which is part of Windows SDK 7.1, need to be installed

### To build Windows installer:
- `git clone https://github.com/uProxy/uproxy-windows-installer.git`
- `install.bat`
- Grab executable files from `dist\%language%\Firefox_with_uProxy.exe` and upload them to [releases](https://github.com/uProxy/uproxy-windows-installer/releases). By default we build versions for English and Chinese.

##### Build for a specfic Firefox version or language:
- We support a couple optional arguments for building specific versions of Firefox
- To build the installer for a specific language: `install.bat -l us-En`
- To build the installer for a specific version of Firefox: `install.bat -v 45.0`
- Another example: `install.bat -v 45.0 -l zh-CN`
- List of possible languages [here](https://ftp.mozilla.org/pub/firefox/releases/45.0.2/win64/)

###To make changes:
- `git clone https://github.com/uProxy/uproxy-windows-installer.git`
- Make a new branch for your changes: git checkout -b your_branch_name origin/master
- Make changes
- In `install.bat`, update the version patch number
- Push changes: git push your_branch_name origin/master
- Create pull request

###When there is a new version of the uProxy Firefox extension:
- Follow the steps above to make changes
- While using Windows, get the url to the newly released uProxy .xpi file at https://addons.mozilla.org/en-US/firefox/addon/uproxy-firefox/. It should look something like this https://addons.mozilla.org/firefox/downloads/file/401357/uproxy_beta-0.8.36-fx-windows.xpi
- In `install.bat`, set the uproxyAddonURL to the new url
- In `install.bat`, update the `Version` and `uProxy Version`
- `git push <your_branch_name> origin/master`
- Create pull request
- If you want to build the new releases, run `install.bat` and upload new executables to [releases](https://github.com/uProxy/uproxy-windows-installer/releases)

###To test a release:
- If you've already installed Firefox on your computer, uninstall Firefox.
- Clear old Firefox data and profiles by deleting two directories: `C:\Users\<user>\AppData\Roaming\Mozilla\` and `C:\Users\<user>\AppData\Local\Mozilla`
- Run the new setup .exe file. Check to see that the landing page is displayed and uProxy is installed.