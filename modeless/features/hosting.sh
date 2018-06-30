# autonomous installation of hosting dependencies, apps and config

# boom! hosting

# not sure exactly why Tomcat has to be installed before apache2 - but this is the only way to make hosting work.
/DietPi/dietpi/dietpi-software install 125

# apache2
apt-get install apache2 -y ;
sudo systemctl stop apache2.service ;

sleep 2 

# put files in right places

# rm -r /etc/apache2/sites-enabled/000-default.conf
# rm -r /etc/apache2/sites-available/000-default.conf
# cp /var/WaveOS/modeless/features/hosting/000-default.conf /etc/apache2/sites-enabled/
# cp /var/WaveOS/modeless/features/hosting/000-default.conf /etc/apache2/sites-available/

# rm -r /etc/apache2/apache2.conf
# mv /var/WaveOS/modeless/features/hosting/apache2.conf /etc/apache2/

# rm -r /var/cgi-bin
# mkdir /var/cgi-bin
# mv /var/WaveOS/modeless/features/modes/* /var/cgi-bin/
# sudo chmod +x /var/cgi-bin/*
# sudo chown root.root /var/cgi-bin

# sleep 2

sudo systemctl start apache2.service ;

# Then we need CGI & Perl running, so the buttons on the mode-select menu will run mode-activation script
cd /etc/apache2/mods-enabled
sudo ln -sT ../mods-available/cgi.load cgi.load
cd

sudo a2enmod cgid
sudo a2enconf serve-cgi-bin

#  create symbolic links
# ln -s /etc/apache2/mods-available/cgid.load /etc/apache2/mods-enabled/
# ln -s /etc/apache2/mods-available/cgid.conf /etc/apache2/mods-enabled/

# restart - always important
sudo systemctl restart apache2
sudo service apache2 restart

# this is required for the update process
sudo apt-get install subversion -y
