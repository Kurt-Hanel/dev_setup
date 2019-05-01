autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'xolox/vim-misc'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdcommenter'
Plug 'davidhalter/jedi-vim'
call plug#end()

map <silent> <C-n> :NERDTreeToggle<CR>
map ; :Files<CR>
nmap s <Plug>(easymotion-s)
"map <c-n> :nerdtreetoggle<CR>
set clipboard=unnamedplus
"map <silent> <C-n> :NERDTreeFocus<CR>
"syntax on
"set tw=120
"set cc=120
"set hi ColorColumn ctermbg=lightblue guibg=lightblue
set number
set spell

colorscheme gruvbox
set background=dark    " Setting dark mode

highlight Visual cterm=reverse ctermbg=NONE

autocmd VimEnter *.py :set cc=120
autocmd VimEnter *.py :hi ColorColumn ctermbg=darkgreen guibg=red
