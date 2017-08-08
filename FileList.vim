" Put files into a list that can be accessed by the user.

" fileList is the global file list.
if exists("fileList")
    " Todo: Check if this is already sourced, because this is a pointless error if it's already being resourced.
    echom "Warning! Global array fileList already exists! fileList plugin will not work as expected!"
endif

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

function! GotoFileForceFunction()
    " Note that this doesn't have exactly the same behavior as gf: Only goes by
    " line, not looking for filename.  Not interested in taking the time to change
    " that.
    let $fileName = getline(getpos('.')[1])
    e! $fileName
endfunction

command! GFF call GotoFileForceFunction()

" Todo: Import files from existing list.
" Todo: Eright (open to the right).

" This is to intitialize the list.
call ClearListFunction()
