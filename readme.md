# NGINX Windows Installer

### Requirement
- [NSIS](https://nsis.sourceforge.io/Download)
- or. You also can download installer on build folder at this repository without rebuilding

### Information basic this installer
- nginx will listen on port `8080`
- Root directory C:/Users/dimas/.gradle
- you can change all above settings on FOLDER_INSTALLATION/conf

### Step install
- Install nginx-service.exe
- Reboot windows (to activate service nginx and ngrok)

### Step install NSIS Linux
```bash
sudo apt-get update -y
sudo apt-get install nsis nsis-* -y
make -f Makefile.ori.txt
```