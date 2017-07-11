" Reformats a JSON object to make it easier to read, because programatically-created ones are one giant line.
" Note that this will remove any line breaks inside of strings.  In the case of ES6+ string templates, that will mess stuff up.

function! ReformatJSON() range

    " Find number of lines, so can join them.
        let lineCount = a:lastline-a:firstline+1

    if lineCount>1
        " Move to first line.
            call setpos('.',[0,lineCount,0,0]);
        " Join lines
            exec "normal ".lineCount."J"
    endif



endfunction
