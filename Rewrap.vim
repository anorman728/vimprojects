" Rewrap is similar to the gqq command with textwidth, but it also uses a hanging
"   indent and can be used on multiple lines of text.  And note that textwidth needs
"   to be set beforehand.
" Probably generally best to use with the F3 hotkey defined below.  Can use
"   count to determine how many rows below to include.  Cannot use directions.
" Very, very useful for docblocks and if not using a version of Vim with the
"   breakindent patch

    function! RewrapFunc() range
        let lines = a:lastline-a:firstline+1
        if lines!=1
            let joinlines = lines-1
            exe ":normal ".lines."J"
        endif
        exe ":normal gqq"
        while line('.')!=a:firstline
            exe ":normal I  "
            exe ":normal k"
        endwhile
    endfunction

    command! -range RewrapCmd <line1>,<line2>call RewrapFunc()
    "map <F3> :RewrapCmd<CR>
    " Commented out because not using this function anymore, and F3 is used for
    " something else.

