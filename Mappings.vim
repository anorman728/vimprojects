" Putting all mappings in one place so they don't cause any conflicts.

map <Tab> :<C-U>MoveToNextTabStopCmd(v:count)<CR>
map <S-Tab> :<C-U>MoveToPreviousTabStopCmd(v:count)<CR>

map <silent><F2> :StarDestar<CR>
map <silent><F3> :DocBlockIndent<CR>
map <silent><F4> :Lineup<CR>
map <silent><F5> :ResourceVimrc<CR>
map <silent><F6> :Commas<CR>

" Because I keep hitting this by mistake and never actually use it.
inoremap <C-p> <Esc>

" Remap scrolling hotkeys to keep cursor in same position.
"map <C-d> :call ScrollCustom(0)<CR>
"map <C-u> :call ScrollCustom(1)<CR>
" Commenting out for now.  This was causing more problems than it solved.
