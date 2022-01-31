set tabstop=4
set shiftwidth=4

syntax enable
filetype plugin indent on
set number
set encoding=UTF-8
call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe'
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

call plug#end()


colorscheme nord
let g:rustfmt_autosave = 1
