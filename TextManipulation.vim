" Functions used in plugins for text manipulation (like Todo2Html).

if has('unix')
    let $newline = "\n"
else
    let $newline = "\r\n"
endif

" Get a file ready for writing.
function! InitializeFile(outputFile)
    call OpenTab()
    call NewFile(a:outputFile)
endfunction

" Open current file in new tab.
function! OpenTab()
    let $a = expand('%')
    tabe $a
endfunction

" Delete output file if it already exists, create new file.
function! NewFile(outputFile)
    if filereadable(a:outputFile)
        call delete(a:outputFile)
    endif
endfunction

" Finalize file
" outputFile is not *currently* be used for anything, but here in case anything
" changes in the future and it's needed.
function! FinalizeFile(outputFile)
    call CloseTab()
endfunction

" Close tab.
function! CloseTab()
    tabclose
    execute ':normal gT'
endfunction

" Append the "message" to the end of the "file".
function! AppendToFile(file,message)
    if filereadable(a:file)
        let $writeCommand = 'w >>'
    else
        let $writeCommand = 'w '
    endif
    let $filePath = fnameescape(a:file)
    new
        normal gg0
        setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
        put=a:message
        silent exec $writeCommand.$filePath
    q
endfunction

" Inject a string into another string.  
" e.g., InjectString("testing ${1} B C","A") will return "testing A B C".
" ATM, no way to escape if you literally want ${1} in the output.  Working on
" it, but low priority at this point.
function! InjectString(inputString, ...)
    let $returnStr = a:inputString
    let $length=len(a:000)
    let i=0
    while i<$length
        let $returnStr = substitute($returnStr,'\${'.(i+1).'}',a:000[i],'g')
        let i += 1
    endwhile
    return $returnStr
endfunction

" Multiply a string, e.g., MultiplyString("testing",2)=="testingtesting".
function! MultiplyString(inputString,scalar)
    let i=0
    let $returnStr=""
    while i<a:scalar
        let $returnStr.=a:inputString
        let i+=1
    endwhile
    return $returnStr
endfunction
