sudo rm -rf /var/www/lengy/src;
sudo mkdir /var/www/lengy/src;
sudo cp -r ~/lengy/src /var/www/lengy;
find /var/www/lengy -type d -exec sudo chmod 755 {} \;
find /var/www/lengy -type f -exec sudo chmod 644 {} \;
