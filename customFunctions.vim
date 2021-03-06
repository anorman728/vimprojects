" Functions

" There are several functions here that are years old and I haven't used in a
" really long time.  I'll probably want to clean them up sometime.

" Font size function
    " It's insanely hard to remember the commands for this because it's so finicky.
    function! FontSize(newsize)
        let setfont = "set guifont="
        if has("unix")
            let fontbase = "Monospace\\\ "
        else
            let fontbase = "Courier\\\ New:h"
        endif
        exe setfont.fontbase.a:newsize
    endfunction
    let $presentation = 16

" Custom Columns functions

    " Function to enable columns demarking tabs.
        function! TabColumns()
            set colorcolumn=1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,65,69,73,77,80,81,85,89,93,97,101,105,109,113,117,120,121
        endfunction
        " Alternate form to make it faster.
        function! TC()
            call TabColumns()
        endfunction

    " Function to enable columns demarking multiples of 10
        function! DecColumns()
            set colorcolumn=10,20,30,40,50,60,70,80,90,100
        endfunction
        " Alternate form
        function! DC()
            call DecColumns()
        endfunction

    " Functions for standard stops.
        function! StopColumns()
            set cc=80,120
        endfunction
        " Alternate form
        function! SC()
            call StopColumns()
        endfunction

" Function to space according to tabstops.  (Assumes tab enters four spaces.)

    function! MoveToNextTabStop(count)
        let save_pos = getpos('.')
        let line_num = save_pos[1]

        let currentColumn = save_pos[2] + save_pos[3]
        let slack = (4-((currentColumn-1)%4))
        if a:count>0
            let keynum = a:count-1
        else
            let keynum = 0
        endif
        let newColumn = currentColumn + slack + keynum*4

        let new_pos = [0,line_num,newColumn,0]

        call setpos('.',new_pos)
        exe ":normal a"
        "Append nothing. Workaround to prevent cursor's column position from changing back when change lines
    endfunction
    command! -nargs=1 MoveToNextTabStopCmd call MoveToNextTabStop(<args>)

    function! MoveToPreviousTabStop(count)
        let save_pos = getpos('.')
        let line_num = save_pos[1]
        let currentColumn = save_pos[2]+save_pos[3]
        let excess = (currentColumn-1)%4
        if excess==0
            let excess=4
        endif
        if a:count>0
            let keynum = a:count-1
        else
            let keynum = 0
        endif
        let newColumn = currentColumn-excess-keynum*4

        let new_pos = [0,line_num,newColumn,0]

        call setpos('.',new_pos)
        exe ":normal a"
        "Append nothing. Workaround to prevent cursor's column position from changing back when change lines
    endfunction
    command! -nargs=1 MoveToPreviousTabStopCmd call MoveToPreviousTabStop(<args>)

" Check if a script is already loaded and source iff not already loaded.
" DO NOT ESCAPE SPACES IN FILENAMES!

    function! ScriptIsLoaded(filePath)
        let $homeDir=expand('~')
        let scriptNamesStr=GetOutput("scriptnames")
        let scriptNamesStr=substitute(scriptNamesStr,'\~',$homeDir,'g')
        if (scriptNamesStr =~ a:filePath)
            return 1
        else
            return 0
        endif
    endfunction

    function! SourceIfNotSourced(filePath)
        if !(ScriptIsLoaded(a:filePath))
            exe ":source ".a:filePath
        endif
    endfunction

" Get value from Vim terminal output into a string.

    function! GetOutput(command)
        redir => returnStr
            silent execute a:command
        redir END

        " Remove "Control" characters, i.e., ^@.
        let returnStr = substitute(returnStr,'[[:cntrl:]]','','g')

        " Trim.
        let $space = '\(\s\|\s\+\)'
        let returnStr = Trim(returnStr, $space)

        return returnStr
    endfunction

" Trim

    function! Trim(inputStr, trimVal)
        let returnStr = a:inputStr
        let regex = '\(^'.a:trimVal.'\|'.a:trimVal.'$\)'
        while match(returnStr, regex) != -1
            let returnStr = substitute(returnStr, '\(^'.a:trimVal.'\|'.a:trimVal.'$\)', '', 'g')
        endwhile
        return returnStr
    endfunction

" Quickly open directory of current file.

    function! ODFunction()
        let $dirPath = expand('%:h')
        e $dirPath
    endfunction

    command! OD call ODFunction()

" Change directory to current file's directory.

    function! CDCFFunction()
        let $dirPath = expand('%:h')
        cd $dirPath
    endfunction

    command! CDCF call CDCFFunction()

" Change directory to current directory currently on screen (assuming using Netrw at the moment).

    function! CDCDFunction()
        let $dirPath = expand('%:p')
        cd $dirPath
    endfunction

    command! CDCD call CDCDFunction()

" Open file from current directory (assuming currently in Netrw).

    if !exists("*OFCDFunction")
        function OFCDFunction(fileName)
            let $dirPath = expand('%:p')
            let $filePath = $dirPath.a:fileName
            e $filePath
        endfunction

        command -nargs=1 OFCD call OFCDFunction(<f-args>)
    endif

" Print working file

    function! PWFFunction()
        echo expand("%:p")
    endfunction

    command! PWF call PWFFunction()

" Open working file in new tab.

    function! TABFFunction()
        let $dirPath = expand('%:p')
        let pos = getpos('.')
        tabe $dirPath
        call setpos('.', pos)
    endfunction

    command! TABF call TABFFunction()

" Return working file (just easier to use)

    function! ThisFile()
        let $thisfile = expand('%:p')
        return $thisfile
    endfunction

    function! TF()
        return ThisFile()
    endfunction

" Set working file to g:filedrawer

    function! SetFileDrawer()
        let g:filedrawer = TF()
    endfunction

    command! SFD call SetFileDrawer()

" Open file drawer.
    function! OpenFileDrawer()
        let $a=g:filedrawer
        e $a
    endfunction

    command! OFD call OpenFileDrawer()

" Q&D clipboard functions.

    function! Paste()
        let $returnval = system('cat ~/clipboard')
        return substitute($returnval, '\n$', '', '')
    endfunction

    function! Copy(input)
        silent exec '! echo "'.a:input.'" > ~/clipboard'
    endfunction

" Toggle autoindent.

    function! ToggleAutoindent()
        "call Debug('set autoindent', GetOutput("set autoindent?"))
        if GetOutput("set autoindent?") == "autoindent"
            set noautoindent
        else
            set autoindent
        endif
    endfunction

    command! TI call ToggleAutoindent()

" Scroll function.

    " Custom scroll function, because I like to keep the cursor where it was.
    " True = up, false = down
    function! ScrollCustom(updown)
        if a:updown
            let updown = "\<c-y>"
        else
            let updown = "\<c-e>"
        endif
        let scrollAmt = winheight('%')/2
        exe "normal " . scrollAmt . updown
    endfunction

" Correct HTML indentation  (This screws up settings!  Only use it in a new window!)
    
    function! CorrectHtmlIndentation()
        %s/</\r</g
        filetype indent on
        set filetype=html
        set smartindent
        normal gg=G
        g/^$/d
    endfunction


" Open current file as HTML in LibreOffice.  This is useful for being able to
" copy-paste into Gmail.

" Note that current iteration will definitely not work in Windows or WSL.  Will
" want to change that someday.

function! ForPasting()
    TOhtml
    sav! /tmp/tmpfile.html
    q
    ! libreoffice --writer /tmp/tmpfile.html
endfunction
