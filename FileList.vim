" Put files into a list that can be accessed by the user.

" Source the TextManipulation plugin.
    let $currentDir=expand("<sfile>:p:h")
    let $textManipulation = $currentDir."/TextManipulation.vim"
    "source $textManipulation
    call SourceIfNotSourced($textManipulation)

function! SetListFile(listFile)
    let g:fileList = a:listFile
endfunction

call SetListFile($HOME . '/fileList')

function! GetListFile()
    return g:fileList
endfunction

function! AddToListFunction()
    let $fileName = expand('%:p')
    call AppendToFile(GetListFile(), fnameescape($fileName))
endfunction

command! ADDTOLIST call AddToListFunction()

function! ViewListFunction()
    exec "e ".GetListFile()
endfunction

command! VIEWLIST call ViewListFunction()

if !exists("*GotoFileForceFunction")
    function! GotoFileForceFunction()
        " Note that this doesn't have exactly the same behavior as gf: Only goes by
        " line, not looking for filename.  Not interested in taking the time to change
        " that.
        let $fileName = getline(getpos('.')[1])
        e! $fileName
    endfunction
endif

command! GFF call GotoFileForceFunction()

" Q&D function to open file to the right.  Will need to refactor to make
" compatible with Netrw on all systems.
    
if !exists("*OpenRightFunction")
    function OpenRightFunction()
        vsp
        exec "normal \<C-w>l"
        call GotoFileForceFunction()
    endfunction
endif

command! OR call OpenRightFunction()

" Q&D function to open file below.

if !exists("*OpenBelowFunction")
    function OpenBelowFunction()
        sp
        exec "normal \<C-w>j"
        call GotoFileForceFunction()
    endfunction
endif

command! OB call OpenBelowFunction()
