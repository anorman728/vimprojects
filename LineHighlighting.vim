" s:xyz means script-wide var.

" Currently best to only use on one file at a time, because the list of line
" numbers can't differentiate between files.
" If start getting funky stuff, call ResetHighlighted.

function! HighlightAdd(lineNum)
    call AddToHighlighted(a:lineNum)
    call UpdateHighlighted()
endfunction

" TODO: Remove from highlighted.

function! ResetHighlighted()
    let s:highlightedRows = []
    let s:highlightedColor = 'Blue'
    call UpdateHighlighted()
endfunction

function! UpdateHighlighted()
    execute 'match highlightRow /' . GetAllHighlightedRowsAsRegex() . '/'
    execute 'hi highlightRow ctermbg=' . s:highlightedColor
endfunction

function! HighlightColor(color)
    let s:highlightedColor = a:color
    call UpdateHighlighted()
endfunction

function! AddToHighlighted(x)
    let s:highlightedRows = s:highlightedRows + [a:x]
endfunction

function! GetHighlighted()
    " Mostly to be able to echo to console.
    return s:highlightedRows
endfunction

function! GetAllHighlightedRowsAsRegex()
    let dumArr = []

    for x in s:highlightedRows
        let dumArr = dumArr + ['\%' . x . 'l']
    endfor

    return join(dumArr, '\|')
endfunction

call ResetHighlighted()

command! -nargs=1 HL call HighlightAdd(<f-args>)
command! HC call HighlightAdd(line('.'))
command! HR call ResetHighlighted()
