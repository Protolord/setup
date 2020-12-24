# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy the text below as .vimrc
cat > ~/.vimrc << EOF
" =============== Plugins ==================== "
" List
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
call plug#end()

" Theme
if !empty(glob('~/.vim/plugged/gruvbox'))
  colorscheme gruvbox
endif

" ================  General ================== "
set nocompatible
set encoding=utf-8
set background=dark
set tags=tags


" ================== UI ====================== "
" Numbers
set number numberwidth=5
set showcmd
set ruler
set scrolloff=3

" Column line
set textwidth=100 colorcolumn=+1

" Tab button
set autoindent
set tabstop=4 shiftwidth=4 expandtab
autocmd FileType yaml,yml setlocal shiftwidth=2 tabstop=2

" Show and trim white space
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd FileType c,cpp,python,yaml autocmd BufWritePre <buffer> :%s/\s\+$//e
" Disable auto-comment on next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Finding files
set wildmenu
set wildmode=list:longest,full
set showmatch
set incsearch
set ignorecase
set smartcase

" ============= Mappings ==================== "
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
nnoremap <C-K> :cnext<cr>
nnoremap <C-J> :cprev<cr>
nnoremap <C-L> gt
nnoremap <C-H> gT
nnoremap <leader>x :Explore<cr>
nnoremap <leader>s :mksession! session.vim<cr>
nnoremap <leader>t :tabnew %<cr>
nnoremap <leader>c :setlocal spell spelllang=en_us<cr>
nnoremap <leader>v :vsplit %<cr>
nnoremap <leader>h :split %<cr>
EOF

# Install plugins
vim +'PlugInstall --sync' +qa

