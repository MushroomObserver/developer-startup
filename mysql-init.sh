echo "mysql-server-5.5 mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password root" | debconf-set-selections
sudo apt-get -y install mysql-server-5.5
sudo apt-get -y install libmysqlclient-dev
