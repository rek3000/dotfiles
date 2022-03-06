set tabstop=4
set shiftwidth=4

syntax enable
filetype plugin indent on
set number
set encoding=UTF-8
call plug#begin('~/.vim/plugged')

Plug 'racer-rust/vim-racer'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'arcticicestudio/nord-vim'
Plug 'https://github.com/ap/vim-css-color'
Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'jiangmiao/auto-pairs'
Plug 'luochen1990/rainbow'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()


colorscheme nord
highlight Visual cterm=reverse ctermbg=NONE

let g:rustfmt_autosave = 1
map <F2> :NERDTreeToggle<CR>

let g:rainbow_active = 1
