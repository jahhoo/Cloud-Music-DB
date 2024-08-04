#/bin/sh
#NAS Music DB
#Author Jan Holomek (jahhoo@gmail.com)

tagVersion="v1.2.2"
version="v1-2-2"

# Update and install Apache2
sudo apt update
sudo apt install -y apache2 exiftool bpm-tools

# Enable and start Apache2 service
sudo systemctl enable apache2
sudo systemctl start apache2

# Create directory and download content
folder="musicdb"
sudo mkdir -p /var/www/$folder
cd /var/www/$folder
sudo wget https://github.com/jahhoo/Cloud-Music-DB/releases/download/$tagVersion/$version.zip
sudo unzip $version
sudo rm $version

# Prompt for username and password
read -p "Enter username [default: music]: " username
username=${username:-music}

read -p "Enter password [default: mymusicdb]: " password
password=${password:-mymusicdb}

# Create .htaccess file
sudo bash -c "cat > /var/www/$folder/.htaccess <<EOF
AuthType Basic
AuthName \"Restricted Content\"
AuthUserFile /var/www/musicdb/.htpasswd
Require valid-user
EOF"

# Create .htpasswd file
sudo htpasswd -cb /var/www/musicdb/.htpasswd $username $password

# Prompt for music directory
read -p "Enter music directory [default: /home/$USER/music]: " music_dir
music_dir=${music_dir:-/home/$USER/music}

# Create symlink
sudo ln -s $music_dir /var/www/musicdb/music

# Update Apache2 configuration
sudo bash -c "cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www

    <Directory /var/www/musicdb>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF"

# Restart Apache2 to apply changes
sudo systemctl restart apache2


chmod +x scanMusic.sh
sudo ./scanMusic.sh &

ip=$(ip addr show | grep 'inet ' | awk '{print $2}' | cut -d/ -f1 | tail -n 1)
echo "Installation and configuration complete! Now the analysis of music files will run for a few minutes."
echo "The application runs at http://$ip/$folder"

