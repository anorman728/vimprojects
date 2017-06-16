" Use F2 to use textwidth property to correctly break comment lines that are too
" long in docblocks, i.e.,
" 
" /**
"  *  Description.
"  * @param   String  varName     This is a really long comment that needs to be broken into multiple lines.
"  *
"  */
" 
" Becomes
" 
" /**
"  *  Description.
"  * @param   String  varName     This is a really long comment that needs to be 
"  *                              broken into multiple lines.
"  *
"  */
" 
" Except the asterisks at the beginning will actually be removed.  (I figured I'll
" end up having to add them after editing anyway.

function! DocBlockIndentFunc()
    " Store current position.
        let posArr = getpos('.')
    " Store whatever user currently has for indentexpr as variable.
        redir => previndentexpr
            silent execute "set indentexpr?" 
        redir END                          
        let previndentexpr = previndentexpr[1:strlen(previndentexpr)]
        " This gets rid of some weird character that screws everything up.
    " Set indent level to current cursor position.
        let $indentlevel = getpos('.')[2]-1
        let $cmd="set indentexpr=".$indentlevel
        exe $cmd
    " Run gqq on line.
        exe ":normal gqq"
    " Reset indentexpr
        let $cmd = "silent! set ".previndentexpr
        exe $cmd
    " Reset position
        call setpos('.',posArr)
endfunction

command! DocBlockIndent call DocBlockIndentFunc()
map <F3> :DocBlockIndent<CR>

function! StarDestarFunc()
    " Get current position (will need to reset to this at the end)
        let currentPosition = getpos('.')
    " Get current line.
        let currentLine = currentPosition[1]
    " Find out if this current line has an asterisk.  Will assume that, if it does, all lines in block do.
        let $test = matchstr(getline(currentLine),'^\(\s\+\)\?[*]')
        if empty($test)
            let $isOn = 1
        else
            let $isOn = 0
        endif
    " Find upper bound (numeric upper bound, not visual upper bound).
        let upperbound = currentLine
        let reachedTop = 0
        while (!reachedTop && upperbound<=line('$'))
            let upperbound = upperbound+1
            let $test = matchstr(getline(upperbound),'^\(\s\+\)\?[*]\/')
            if !empty($test)
                let reachedTop = 1
            endif
        endwhile
        if upperbound>line('$')
            throw "Not currently in a docblock."
        endif
    " Find lower bound (numeric lower bound, not visual lower bound).
        let lowerbound = upperbound
        let reachedBottom = 0
        while (!reachedBottom)
            let lowerbound = lowerbound-1
            let $test = matchstr(getline(lowerbound),'^\(\s\+\)\?\/[*]')
            if !empty($test)
                let reachedBottom = 1
            endif
        endwhile
    " Exit if cursor is not currently in a docblock.
        if lowerbound>currentLine
            throw "Not currently in a docblock."
        endif
    " Get column to use to toggle asterisks.
        let toggleCol = match(getline(lowerbound),'[*]')+1
    " Select visual block and toggle.
        call setpos('.',[0,lowerbound+1,toggleCol,0])
        exe "normal \<C-v>"
        call setpos('.',[0,upperbound-1,toggleCol,0])
        if $isOn
            exe "normal r*"
        else
            exe "normal r "
        endif
    " Restore previous position.
        call setpos('.',currentPosition)

endfunction

command! StarDestar call StarDestarFunc()
map <F2> :StarDestar<CR>


