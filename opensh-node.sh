#!/bin/bash
echo "OPENCV 3.1 INSTALLER FOR UBUNTU"

cd ~
mkdir .ssh
mv /root/id_rsa  /root/.ssh
mv /root/id_rsa.pub /root/.ssh
mv /root/known_hosts /root/.ssh
chmod 600 /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa.pub

apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils

apt-get install -y nano 
apt-get install -y unzip wget 
apt-get install -y build-essential git cmake pkg-config 
apt-get install -y libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev 
apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
apt-get install -y libgtk2.0-dev
apt-get install -y libatlas-base-dev gfortran

cd ~
git clone git@bitbucket.org:guillealk/warden_camera.git

cd ~
wget https://github.com/Itseez/opencv/archive/3.1.0.zip
unzip 3.1.0.zip
mv 3.1.0.zip opencv-3.1.0.zip   # avoid naming conflic
#make sure you've got a 'opencv-3.1.0' directory named

cd ~
wget https://github.com/Itseez/opencv_contrib/archive/3.1.0.zip
unzip 3.1.0.zip
#rename the directory such this: 'opencv_contrib'
mv opencv_contrib-3.1.0/ opencv_contrib

cd ~
apt-get install python2.7-dev
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

#**************** only for virtualenvironment *************
# Installing virtualenv  and virtualenvwrapper  is as simple as using the pip  command:
pip install virtualenv virtualenvwrapper

# Next up, we need to update our ~/.profile  file by opening it up in your favorite editor and adding the following lines to the bottom of the file.
# update your ~/.profile file   --instead used: .bashrc
# virtualenv and virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7 >> ~/.bashrc
export WORKON_HOME=$HOME/.virtualenvs >> ~/.bashrc
source /usr/local/bin/virtualenvwrapper.sh >> ~/.bashrc
# And if your ~/.profile  file does not exist, create it.
# Now that your ~/.profile  file has been updated, you need to reload it so the changes take affect. To force a reload of the . profile , you can: logout and log back in; close your terminal and open up a new one; or the most simple solution is to use the source  command:
source ~/.bashrc

#**************** only for virtualenvironment *************
mkvirtualenv cv3
workon cv3

pip install numpy
echo "if the previous command failed: issue this and retry: sudo rm -rf ~/.cache/pip/"

cd ~/opencv-3.1.0/
mkdir build
cd build
# make sure that INSTALL_C_EXAMPLES is OFF
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	-D BUILD_EXAMPLES=OFF ..

echo "If the cmake command failed: Try clearing the cache issuing: rm CMakeCache.txt"

#Sample output on success:
#  Python 2:
#--     Interpreter:                 /home/user/.virtualenvs/cv3/bin/python2.7 (ver 2.7.11)
#--     Libraries:                   /usr/lib/x86_64-linux-gnu/libpython2.7.so (ver 2.7.11+)
#--     numpy:                       /home/user/.virtualenvs/cv3/local/lib/python2.7/site-packages/numpy/core/include (ver 1.11.0)
#--     packages path:               lib/python2.7/site-packages

make -j4
make install
ldconfig

# Take a second to investigate the contents of this directory
# You should see a file named cv2.so , which is our actual Python bindings. The last step we need to take is sym-link the cv2.so  file into the site-packages  directory of our cv3  environment:
ls -l /root/opencv-3.1.0/build/lib/
cd ~/.virtualenvs/cv3/lib/python2.7/site-packages/
ln -s /root/opencv-3.1.0/build/lib/cv2.so cv2.so

source ~/.virtualenvs/cv3/bin/activate

python warden_camera/horses/backend_horse.py cam1
