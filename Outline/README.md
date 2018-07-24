sudo apt-get install net-tools nano git wget unzip p7zip curl -y
sudo apt-get update && sudo apt upgrade -y

Install Docker
You will need to install Docker on your server first. If not, run the following command:

sudo curl -sS https://get.docker.com/ | sh

Install Outline
All you need to do is run this command:

sudo wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh | bash
When you finished, the output should be like:
Please copy the following configuration to your Outline Manager:

{"apiUrl":"https://68.100.18.234:33276/CyhVMBxgSxL_HvTGGYBGDQ","certSha256":"49AE499CCB291072A92295908EA559342DAAD634DEA4431D7F9465AA8BC460EE"}

Just leave it there. You will need these information in the next step. That's enough for the server side. Now, we will move to the client side.

Get the access key
Open Outline Manager. Scrool down to the Advanced Mode and click on Get started button;
Copy everything within (include) the {} of the key on your server at the last step and paste it the field at the next screen;
Click Done;
There is a key automatically created for you (named 'My Access Key'). If you click 'Get Connected' next to it, you will be walked through how to download the appropriate client for your platform without needing to open up a new page. (Thanks to r/sandrigo);
If you want to get a new key to share with your friends, Click Add key, and you will get something like "Key 1", click Share, it will show you the link to get the access key, click Copy to Clipboard and send it to your friends. (HEADS UP: EVERYONE WHO HAS THE LINK WILL BE ABLE TO CONNECT TO YOUR SERVER)
https://s3.amazonaws.com/outline-vpn/index.html#/invite/ss//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Paste it to browser
Click on Connect this device, it will show you the key, click Copy to get the key.
Connect to Outline
Outline supports macOS, Windows, iOS, Android and Chrome OS.

Windows

Windows 7.0+
Use this link to download Outline for Windows

https://raw.githubusercontent.com/Jigsaw-Code/outline-releases/master/client/Outline-Client.exe
Install Outline for Windows to your computer. Open it.
Click on + button at the upright corner.
Paste the key you copied above to the field and click Add server
Click Connect at the next screen, wait until it connected.
Enjoy.
Note: If it shows "key invaild", just try to reconnect several times.

Android

Android 5.0+
https://play.google.com/store/apps/details?id=org.outline.android.client
https://github.com/Jigsaw-Code/outline-releases/blob/master/client/Outline.apk
Download Outline for Android from the CH Play or Github, and repeat the steps for Windows above.

