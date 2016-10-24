" I really don't like the way that jsdoc organizes everything into classes instead
" of files (because not a lot of people use OOP JS).  This just lists out all the
" docblocks, pretty much.

" For this to work, must use function <functionname> syntax instead of the
" function constructor or var myFunction = function(x)...

" This is basically a giant procedure.  Since it's a tool for myself, and it's
" not SUPER complicated, I decided against making it particularly well-designed.

" For this to work correctly, this script assumes you use autoindent.  It would
" take extra time to make this compatible with all forms of indentation.

" Since I made this tool for myself, I didn't go to extra lengths to make it
" very flexible, but, of course, you can modify it any way that you like if you're
" reading this.

function! JSdoc()
    " Get current position (will need to restore in the end)
        let initialPos = getpos('.')
    " Get number of last line of file.
        exe "normal G"
        let endLine = getpos('.')[1]
    " Restore position.
        call setpos('.',initialPos)
    " Troll through the lines to get docblocks.
        let i=1
        let $docblock = ''
        let $functionName = ''
        let $output = ''
        let inDocBlock = 0
        while i<=endLine
            " Find start of docblock.
                let $test01 = matchstr(getline(i),'^\(\s\+\)\?\/[*][*]')
                if !empty($test01)
                    let inDocBlock = 1
                endif
            " Find end of docblock
                let $test02 = matchstr(getline(i),'^\(\s\+\)\?[*]\/')
                if !empty($test02)
                    let inDocBlock = 0
                endif
            " Add to docblock.
                if inDocBlock && empty($test01)
                    let $line = substitute(getline(i),'^\(\s\+\)\?[*]','','')
                    let $docblock = $docblock."\r\t".$line
                endif
            " Find function (only if it includes a docblock).
                let $test = matchstr(getline(i),'^\(\s\+\)\?function')
                if !empty($test) && !empty($docblock)
                    let $functionName = matchstr(getline(i),'function.\{-}(')
                    let $functionName = substitute($functionName,'^function','','')
                    let $functionName = substitute($functionName,'(','','')
                    
                    let $output = $output."\r\r".$functionName."\r".$docblock

                    let $docblock = ''
                endif
            let i = i + 1
        endwhile
    " Trim line breaks.
        let $output = substitute($output,'^\r\r','','')
    " Open new tab with results.
        tabe
        set noautoindent
        exe ":normal i".$output
        set autoindent
endfunction
