# dotfiles
my dotfiles open to the world


#setup TMUX version a set version to copy commands

sudo killall -9 tmux
sudo apt-get -y remove tmux

# Setup 
VERSION=2.8
wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
tar xf tmux-${VERSION}.tar.gz
rm -f tmux-${VERSION}.tar.gz

#Build
cd tmux-${VERSION}
./configure
make
sudo make install
cd -
sudo rm -rf /usr/local/src/tmux-\*
sudo mv tmux-${VERSION} /usr/local/src


#exit terminal after install 
