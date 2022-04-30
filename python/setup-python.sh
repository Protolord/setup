for item in python3 pip3; do
  if [[ ! $(which ${item}) ]]; then
    echo "No ${item} was found on this machine, setup cancelled"
    exit 1
  fi
  if ! grep -q "alias ${item::-1}='${item}'" ~/.bashrc; then
    echo "alias ${item::-1}='${item}'" >> ~/.bashrc
  fi
done

# Install syntax checker and code-completion for vim
pip3 install flake8
if [[ $(which vim) && -f ~/.vimrc ]]; then
  plugin_autocomplete="Plug 'davidhalter/jedi-vim'"
  if ! grep -q "$plugin_autocomplete" ~/.vimrc; then
    sed -i "s|call plug#end()|$plugin_autocomplete\ncall plug#end()|g" ~/.vimrc || exit
  fi
  vim +'PlugInstall --sync' +qa
fi;

# Reset shell session
bash
