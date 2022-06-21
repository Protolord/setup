if [[ ! $(which vim) ]]; then
  echo "No vim was found on this machine, setup cancelled"
  exit 1
fi
# Remove existing plugins and configs
if [[ -d ~/.vim ]]; then
  rm -rf ~/.vim
fi
if [[ -f ~/.vimrc ]]; then
  rm ~/.vimrc
fi

# Install vim-plug
sudo apt update
sudo apt install curl
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy the text below as .vimrc
cat > ~/.vimrc << EOF
" =============== Plugins ==================== "
" List "
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-fugitive'
Plug 'frazrepo/vim-rainbow'
Plug 'hashivim/vim-terraform'
call plug#end()

" Plugin configurations "
if !empty(glob('~/.vim/plugged/gruvbox'))
  colorscheme gruvbox
endif

if !empty(glob('~/.vim/plugged/vim-airline'))
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  let g:airline#extensions#tabline#tab_nr_type = 2
  let g:airline#extensions#tabline#tabs_label = ''
  let g:airline#extensions#tabline#show_buffers = 0
  if !empty(glob('~/.vim/plugged/ale'))
    let g:airline#extensions#ale#enabled = 1
  endif
endif

if !empty(glob('~/.vim/plugged/ale'))
  let g:ale_echo_msg_format = '[%linter%] %code%: %s'
  let g:ale_lint_on_enter = 0
  nmap <silent> <C-e> <Plug>(ale_next_wrap)
endif

if !empty(glob('~/.vim/plugged/vim-rainbow'))
  let g:rainbow_active = 1
endif

" ================  General ================== "
set nocompatible
set backspace=indent,eol,start
set encoding=utf-8
set background=dark
set tags=tags


" ================== UI ====================== "
" Numbers "
set number numberwidth=5
set showcmd
set ruler
set scrolloff=3

" Netrw "
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 20
let g:netrw_altv = 1
let g:netrw_list_hide= '.*\.swp$'

" Column line "
set textwidth=100 colorcolumn=+1

" Folding "
set foldmethod=indent
set foldlevel=99

" Tab spacing "
set autoindent
set tabstop=4 shiftwidth=4 expandtab
autocmd FileType c,cpp,go,python \
  set tabstop=4 softtabstop=4 shiftwidth=4 fileformat=unix
autocmd FileType css,html,javascript,json,sh,typescript,yaml \
  set shiftwidth=2 tabstop=2 fileformat=unix

" Show and trim white space "
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd FileType c,cpp,go,javascript,python,sh,typescript,yaml \
  autocmd BufWritePre <buffer> :%s/\s\+$//e

" Disable auto-comment on next line "
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Finding files "
set path+=**
set wildmenu
set wildmode=list:longest,full
set wildignore+=./**/node_modules/**
set wildignore+=./**/build/**
set showmatch
set incsearch
set ignorecase
set smartcase

" ============= Mappings ==================== "
nnoremap <space> <nop>
let mapleader = "\<space>"
inoremap kj <esc>
nnoremap <c-k> :cnext<cr>
nnoremap <c-j> :cprev<cr>
nnoremap <c-l> gt
nnoremap <c-h> gT
nnoremap <c-p> :find<space>
nnoremap <c-x> :Lexplore<cr>
vnoremap <c-c> y : call system("xclip -i -selection clipboard", getreg("\""))<cr>
nnoremap <leader>x :Explore!<cr>
nnoremap <leader>b :below terminal ++rows=10<cr>
nnoremap <leader>s :mksession!<cr>
nnoremap <leader>t :tabnew %<cr>
nnoremap <leader>l :setlocal spell spelllang=en_us<cr>
nnoremap <leader>v :vsplit<cr>
nnoremap <leader>h :split<cr>
nnoremap <leader>f :vimgrep // ./**/*<left><left><left><left><left><left><left><left>
EOF

# Install plugins
vim +'PlugInstall --sync' +qa

# Install xclip
sudo apt install -y xclip

# Make vim the default editor for git
git config --global core.editor "vim"
