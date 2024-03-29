
set guioptions-=m
set guioptions-=T
set guioptions-=e
set guioptions-=r
set guioptions-=L

set guifont=Ubuntu\ Mono:h14

set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

set expandtab
set softtabstop=2
set shiftwidth=2

set wmh=0

map <C-J> <C-W>j<C-W>_
map <C-k> <C-W>k<C-W>_

map K i<Enter><ESC>l

nnoremap <C-F> :Ag! "<C-R><C-W>"<CR>

set guioptions+=c
set noea
set list

set noshowmode
set nofoldenable

set ignorecase
set smartcase

set vb t_vb=

function! g:ToggleColorColumn()
  if &colorcolumn != ''
    call g:DisableColorColumn()
  else
    call g:EnableColorColumn()
  endif
endfunction

function! g:EnableColorColumn()
  call g:EnableColorColumnSilent()
  echo 'colorcolumn on'
endfunction

function! g:EnableColorColumnSilent()
  execute "set colorcolumn=" . join(range(80,255), ',')
  hi OverLength guibg=#073642 ctermbg=0
endfunction


function! g:DisableColorColumn()
  hi OverLength guibg=NONE ctermbg=NONE
  setlocal colorcolumn&
  echo 'colorcolumn off'
endfunction

nnoremap com :call g:ToggleColorColumn()<CR>
nnoremap [om :call g:EnableColorColumn()<CR>
nnoremap ]om :call g:DisableColorColumn()<CR>

call g:EnableColorColumnSilent()

match OverLength /\%77v.*/

" We also use &cul to determine whether we're the active
" window or not for use in statusline
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END
set cul

function! StatusLine()
  let grey="%2*"
  let orange="%3*"
  let blue="%4*"
  let red="%5*"
  let green="%6*"
  let yellow="%7*"
  let reset="%*"

  let separator = grey . "\ ~\ " . reset
  let format = "%{&ff}"
  let encoding = "%{strlen(&fenc)?&fenc:'none'}"

  let normalMode = yellow . "%{&cul&&mode()=='n'?'N':''}" . reset
  let insertMode = blue . "%{&cul&&mode()=='i'?'I':''}" . reset
  let replaceMode = red . "%{&cul&&mode()=='r'?'R':''}" . reset
  let visualMode = green . "%{&cul&&(mode()=='v'||mode()=='V'||mode()=='')?'V':''}" . reset
  let noMode = "%{&cul?'':'\ '}"

  let currentMode = normalMode . insertMode . replaceMode . visualMode . noMode

  let modifiedFile = orange . "%{&modified?bufname('%'):''}" . reset
  let unmodifiedFile = green . "%{!&modified&&!&readonly?bufname('%'):''}" . reset
  let readonlyFile = red . "%{!&modified&&&readonly?bufname('%'):''}" . reset

  let file = "%<" . modifiedFile . unmodifiedFile . readonlyFile

  let syntastic_disabled = grey . "%{!&cul?'\ /\ ':'-/-'}"
  let syntastic = syntastic_disabled

  if &ft != ''
    \ && len(g:SyntasticRegistry.Instance().getCheckersAvailable(&ft, [])) > 0

    let synErrorCount = len(g:SyntasticLoclist.current().errors())
    let warnings = g:SyntasticLoclist.current().warnings()

    if type(warnings) == type([])
      let synWarnCount = len(warnings)
    else
      let synWarnCount = warnings
    endif

    let isNoErrors = synErrorCount == "0"
    let isNoWarns = synWarnCount == "0"

    if len(synErrorCount) > 1
      let synErrorCount ="T"
    endif

    if len(synWarnCount) > 1
      let synWarnCount = "T"
    endif

    let synWarnCount = "%{&cul?'" . synWarnCount . "':' '}"
    let synErrorCount = "%{&cul?'" . synErrorCount . "':' '}"

    if isNoErrors
      let errs = grey . synErrorCount . reset
    else
      let errs = red . synErrorCount . reset
    endif

    if isNoWarns
      let warns = grey . synWarnCount . reset
    else
      let warns = yellow . synWarnCount . reset
    endif

    let syntastic = errs . grey . "/" . reset . warns
  endif

  let s = ''
  let s .= currentMode . separator . file

  let s .= "%=\ "
  let s .= format . grey . "/" . reset . encoding
  let s .= separator . syntastic
  let s .= separator . "%3l:%2v"

  return s
endfunction

set statusline=%!StatusLine()

execute pathogen#infect()

if executable('ag')
  let g:ctrlp_user_command='ag -l --nocolor -g "" %s'
  let g:ctrlp_use_caching=0
endif

let g:solarized_termtrans=1
let g:solarized_menu=0

set background=dark
colorscheme solarized

if $TERM == 'screen-256color'
  autocmd ColorScheme * execute 'source ~/.vimrc'
endif

map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeChDirMode=2
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeShowBookmarks=1

let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_enable_ballons=0
let g:syntastic_always_populate_loc_list=1
let g:syntastic_javascript_checkers = []

" Always display the sign column
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

hi! SignColumn guibg=#073642 ctermbg=0

hi SyntasticError ctermfg=NONE ctermbg=NONE cterm=NONE gui=undercurl guisp=#b58900
hi SyntasticWarning gui=undercurl guisp=#dc322f ctermfg=NONE ctermbg=NONE cterm=NONE

hi SyntasticErrorSign guifg=#dc322f  guibg=#073642 gui=bold ctermfg=1 cterm=bold ctermbg=0
hi SyntasticWarningSign guifg=#b58900 guibg=#073642 gui=bold ctermfg=3 cterm=bold ctermbg=0s

hi StatusLine guifg=#073642 ctermfg=0 guibg=#b58900 ctermbg=3
hi StatusLineNC guifg=#073642 ctermfg=0 guibg=#586e75 ctermbg=10

hi TabLineSel guibg=#cb4b16 ctermbg=9 guifg=#073642 ctermbg=0
hi TabLine guifg=#586e75 ctermfg=10 guibg=#073642 ctermbg=0
hi TabLineFill guifg=#586e75 ctermfg=10 guibg=#073642 ctermbg=0

hi CursorLineNr gui=NONE cterm=NONE guifg=#93a1a1 ctermfg=14 guibg=#073642 ctermbg=0

hi SyntasticWarning gui=undercurl guisp=#b58900 cterm=undercurl
hi SyntasticError gui=undercurl guisp=#dc322f cterm=undercurl

"" Status line colors
" Light Grey (base0)
hi User1 guifg=#839496 ctermfg=12 guibg=#073642 ctermbg=0
" Dark Grey (base01)
hi User2 guifg=#586e75 ctermfg=10 guibg=#073642 ctermbg=0
" Orange
hi User3 guifg=#cb4b16 ctermfg=9 guibg=#073642 ctermbg=0
" Blue
hi User4 guifg=#268bd2 ctermfg=4 guibg=#073642 ctermbg=0
" Red
hi User5 guifg=#dc322f ctermfg=1 guibg=#073642 ctermbg=0
"Green
hi User6 guifg=#859900 ctermfg=2 guibg=#073642 ctermbg=0
"Yello
hi User7 guifg=#b58900 ctermfg=3 guibg=#073642 ctermbg=0

function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    "let s .= ' ' . tab .':'
    let s .= (bufname != '' ? ' ' . fnamemodify(bufname, ':t') . ' ' : ' [No Name] ')
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()

