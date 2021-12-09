# Remove existing vims
sudo apt remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common

# Delete shared folder and vim binary
sudo rm -rf /usr/local/share/vim
sudo rm $(which vim)

# Download and build
vim_src_location="$HOME/.local/src/"
mkdir -p $vim_src_location
cd $vim_src_location
sudo git clone https://github.com/vim/vim
cd vim/src
sudo make distclean
sudo ./configure \
         --with-features=huge \
         --enable-clipboard \
         --disable-netbeans \
         --enable-python3interp=yes \
         --with-python3-config-dir=$(python3-config --configdir) \
         --enable-cscope || exit
sudo make
sudo make install
vim --version
