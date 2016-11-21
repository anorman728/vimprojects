" Deobfuscate files.

function! DeobfuscateJS()
    " Put everything on a single line (because the line breaks are largely arbitrary anyway).
        exec ":normal ggVGgJ"
    " Add line breaks where appropriate.
        silent %s/;/;\r/g
        silent %s/{/{\r/g
        silent %s/}/\r}\r/g
    " Add indentation based on brackets.
        " Note that because of above, there are no cases in which more than one { or } appear on the same line.  There is no need to worry about more than one instance on a line.
        let indentlevel= 0
        let linenumber = 1
        while linenumber<=line('$')
            " Decrease indent, if needed.
                if match(getline(linenumber),'}')!=-1
                    let indentlevel -= 1
                endif
            " Insert indent
                if indentlevel>0
                    call setpos('.',[0,linenumber,0,0])
                    exec ":normal ".indentlevel."I    "
                endif
            " Increase next line's indent, if needed.
                if match(getline(linenumber),'{')!=-1
                    let indentlevel += 1
                endif
            let linenumber = linenumber+1
        endwhile
    " Put cursor on top.
        call setpos('.',[0,0,0,0])
endfunction
