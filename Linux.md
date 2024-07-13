# Create new user and provide root permissions..
# Connect to the Linux machine
ssh username@linux-ip

# Switch to root or use sudo
sudo su -

# Create a new user
adduser newuser

# Add the user to the sudo group
usermod -aG sudo newuser

# Verify sudo permissions
su - newuser
sudo ls /root

# Exit from newuser session
exit

# Exit from root session
exit
