# Remove existing vims
sudo apt remove -y --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common

# Delete shared folder and vim binary
if [[ -d /usr/local/share/vim ]]; then
  sudo rm -rf /usr/local/share/vim
fi
if [[ $(which vim) ]]; then
  sudo rm $(which vim)
fi

# Download and build
vim_src_location="$HOME/.local/src/"
if [[ -d ${vim_src_location} ]]; then
  sudo rm -rf ${vim_src_location}
fi
mkdir -p ${vim_src_location}
cd ${vim_src_location}
sudo git clone https://github.com/vim/vim
cd vim/src
sudo apt update
sudo apt install -y make build-essential libncurses5-dev python3-dev
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
