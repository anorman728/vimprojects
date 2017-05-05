"   New version: Every space at the beginning of a line is an indent level.
"   Useful for docblocks.

set foldmethod=expr
set foldexpr=ModifiedIndent(v:lnum)
set foldlevel=99

" foldignorearray defines patterns to determines what lines to ignore when
" assigning it a fold level.  If any of these patterns are found anywhere on the
" line, it's assigned the fold level of the line that's above it.
" This makes it similar to foldignore, but not the same.  For one, it's an array
" that matches patterns instead of single characters.  Secondly, it doesn't need
" to be at the beginning of the line.  It's not necessary to make that
" requirement since it's pattern-matching.

" foldignorearray can be modified by the user on-the-fly, but it's probably
" easier to just go ahead and modify this file instead.

    let foldignorearray = ['^_','^\(\s\+\)\?$','^\(\s\+\)\?\/\/']

function! ModifiedIndent(lnum)

    let $line = getline(a:lnum)
    for $regex in g:foldignorearray
        if match($line,$regex)!=-1
            return ModifiedIndent(a:lnum+1)
        endif
    endfor

    return ModifiedIndentLevel(a:lnum)

endfunction

function! ModifiedIndentLevel(lnum)
    if a:lnum>line('$')||a:lnum<1
        return 0
    endif
    return float2nr(ceil(str2float(indent(a:lnum))/str2float(&shiftwidth)))
endfunction


" Here is a previous version of the inside of the conditional.  It made the folds
" look better, but significantly slowed down loading time for each file, so I
" decided it wasn't a good idea.
" Even so, I thought it would be best to put in the comments in case I decide
" later to improve it.
"      
"   let prevIndent = ModifiedIndent(a:lnum-1)
"   let nextIndent = ModifiedIndent(a:lnum+1)
"   if prevIndent>nextIndent
"       return prevIndent
"   else 
"       return nextIndent
"   endif
