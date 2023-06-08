set nocompatible

filetype off

" Manage plugins with minpac
packadd minpac
call minpac#init()

command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()

" git plugin
call minpac#add('tpope/vim-fugitive')

" bunch of bracket mappings
call minpac#add('tpope/vim-unimpaired')

" ripgrep plugin
call minpac#add('xavfernandez/vim-ripgrep')

" fzf to find files
call minpac#add('junegunn/fzf.vim')

" Blackify Python files
call minpac#add('psf/black')

call minpac#add('davidhalter/jedi-vim')
call minpac#add('airblade/vim-gitgutter')
"Plugin 'altercation/vim-colors-solarized'
call minpac#add('ervandew/supertab')
" Better substitution
call minpac#add('tpope/vim-abolish')
" Status bar
call minpac#add('bling/vim-airline')

" Asynchronous Lint Engine
call minpac#add('dense-analysis/ale')


autocmd bufreadpre *.js setlocal sts=2 sw=2

filetype plugin indent on    " required

let mapleader=","

" Use Ctrl-P to find files
nnoremap <C-p> :<C-u>FZF<CR>

" Prefix all fuzzy finder commands with Fzf
let g:fzf_command_prefix = 'Fzf'

" Seach in open buffers
map <leader>b :FzfBuffers<cr>

" Display all matching files when we tab complete
set wildmenu

set autoindent              " always set autoindenting on
set smartindent             " use smart indent if there is no indent file
set tabstop=4               " <tab> inserts 4 spaces 
set shiftwidth=4            " but an indent level is 2 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well
set foldmethod=indent       " allow us to fold on indents
set foldlevel=99            " don't fold by default
set history=200             " boost history limit

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set smarttab                " Handle tabs more intelligently 
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ 

set number                    " Display line numbers
set numberwidth=1             " using only 1 column (and 1 space) while possible
set wildignore+=*.pyc,*.zip,*.pyo


" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" CtrlP
"let g:ctrlp_working_path_mode = 'ra'
"let g:ctrlp_match_window = 'max:50'
"let g:ctrlp_max_files = 100000
"let g:ctrlp_custom_ignore = '\v[\/](\.(git|hg|svn))|node_modules$'
"map <leader>r :CtrlPClearAllCaches<cr>

" hide matches on <leader>/
nmap <silent> <leader>/ :nohlsearch<CR>

" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Rg shortcut
nnoremap <leader>r :Rg 

set wildmode=longest:full,list:longest "Xavier: do not fully complete path

" let g:jedi#show_function_definition = "0"
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#rename_command = ""

set hidden             "Allow to hide modified buffer

let g:pyflakes_use_quickfix = 0

"au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"

set completeopt=menuone,longest,preview

" Show tabs and trailing spaces
set list
set listchars=tab:>.,trail:.

" Add the virtualenv's site-packages to vim path
"python << EOF
"import os.path
"import sys
"import vim
"if 'VIRTUAL_ENV' in os.environ:
"    project_base_dir = os.environ['VIRTUAL_ENV']
"    sys.path.insert(0, project_base_dir)
"    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"    execfile(activate_this, dict(__file__=activate_this))
"    #print sys.path
"EOF

syntax enable
"set background=dark
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
"colorscheme solarized

"set t_Co=16

" Enable w!! to sudo after editing
cmap w!! w !sudo tee % >/dev/null

autocmd Filetype gitcommit setlocal spell textwidth=72

" Automatically close fugitive buffers when hiding them
autocmd BufReadPost fugitive://* set bufhidden=delete

" Allow quickly going back one level when browsing trees in fugitive
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" Helper for vim-vue plugin
autocmd FileType vue syntax sync fromstart


" Keep undo history across sessions, by storing in file.
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

nnoremap <LEADER>pdb iimport pdb;pdb.set_trace()

" Search in templates directories in Django projects
set path+=*/templates

" ALE configuration
let g:ale_lint_on_save = 1
let g:ale_fixers = { 'python': ['ruff'] }
