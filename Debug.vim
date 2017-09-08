" Debug function will allow better debugging tools (hopefully).  It will echo it
" out to $HOME./vimdebug

call SourceIfNotSourced($textManipulation)
let g:debugFile = $HOME.'/vimdebug'

function! SetDebugFile(file)
    let g:debugFile = a:file
endfunction

function! GetDebugFile()
    return g:debugFile
endfunction

function! DebugStr(msg, valueArray)
    let $currentTime = strftime('%c')
    let $returnStr = '<<<\n'
    let $returnStr.= $currentTime . ', message: '.a:msg.'\n'
    let length = len(a:valueArray)
    let i = 0
    while i < length
        let $returnStr.= a:valueArray[i] . '\n'
        let i += 1
    endwhile
    let $returnStr.= '>>>\n'
    return $returnStr
endfunction

function! Debug(msg, ...)
    call AppendToFile(g:debugFile, DebugStr(a:msg, a:000))
endfunction

