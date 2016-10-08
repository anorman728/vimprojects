" Expression for slightly better indent folding (imo): If a line's indent level is
"   zero, then check to see if the line above has an indent level greater than 1.
"   If it does, then the current line will be assigned the same foldlevel as
"   that line.  This is helpful for <<< style strings.

" Not enabled by default-- set foldmethod=expr to enable it.
" Can really slow down large files (like the help file), so prefer to disable it by default.

"set foldmethod=expr
set foldexpr=ModifiedIndent(v:lnum)
"set foldlevel=99

function! ModifiedIndent(lnum)
    let currentLineIndent = GetIndentLevel(a:lnum)

    if (currentLineIndent==-1 || currentLineIndent==0) && a:lnum==1
        let currentLineIndent=0
    endif

    if a:lnum>1

        if currentLineIndent==0
            let prevLineIndent = ModifiedIndent(a:lnum-1)
            if prevLineIndent>1
                let currentLineIndent = prevLineIndent
            endif
        endif

        if currentLineIndent==-1
            let currentLineIndent = ModifiedIndent(a:lnum-1)
        endif

    endif

    return float2nr(currentLineIndent)

endfunction

function! GetIndentLevel(lnum)
    let $linecontent = getline(a:lnum)

    if ($linecontent=="")
        return -1
    endif

    let a=0
    while strpart($linecontent,a,1)==" "
        let a = a+1
    endwhile

    let returnVal = floor(a/4)
    return returnVal
endfunction


