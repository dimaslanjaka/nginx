# NGINX Windows Installer

### Requirement
- [NSIS](https://nsis.sourceforge.io/Download)
- or. You also can download installer on build folder at this repository without rebuilding

### Information basic this installer
- configure nginx on FOLDER_INSTALLATION/conf
- configure port ngrok on FOLDER_INSTALLATION/ngrok/config.json

### Step install
- Install nginx-service.exe
- Configure nginx configuration on FOLDER_INSTALLATION/conf
- Reboot windows (to activate service nginx and ngrok)

### Step install NSIS Linux
```bash
sudo apt-get update -y
sudo apt-get install nsis nsis-* -y
# install without ngrok
make -f Makefile.ori.txt
```

### Install using automake
```bash
sudo apt-get update -y
sudo apt-get install -y automake
sudo apt install build-essential -y
sudo apt-get install manpages-dev -y
sudo apt-get update -y
sudo apt-get install nsis nsis-* -y
make
```