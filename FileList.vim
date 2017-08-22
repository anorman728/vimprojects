" Put files into a list that can be accessed by the user.

function! AddToListFunction()
    let $fileName = expand('%:p')
    call add(g:fileList, $fileName)
endfunction

command! ADDTOLIST call AddToListFunction()

function! ViewListFunction()
    enew
    call setline(1,g:fileList)
    sav! /tmp/filelist
endfunction

command! VIEWLIST call ViewListFunction()

function! ClearListFunction()
    let g:fileList = []
endfunction

command! CLEARLIST call ClearListFunction()

function! RmFromListFunction()
    let dumArr = []
    let $deletedFile = expand('%:p')
    for $fileName in g:fileList
        if ($fileName != $deletedFile)
            call add(dumArr,$fileName)
        endif
    endfor
    let g:fileList = dumArr
endfunction

command! RMFROMLIST call RmFromListFunction()

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

" Todo: Import files from existing list.
" Todo: ERIGHT (open to the right).

" fileList is the global file list.
if !exists("fileList")
    " Todo: Do something to warn user if fileList is not an array.
    " Initialize the list.
    call ClearListFunction()
endif

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
