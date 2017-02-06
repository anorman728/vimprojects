" Functions

    " Create shortcut to insert/append value in variable.

        function! Insert(input)
            exe ":normal i".a:input
        endfunction
        
        function! Append(input)
            exe ":normal a".a:input
        endfunction

    " Font size function
        " It's hard as hell to remember the commands for this because it's so finicky.
        function! FontSize(newsize)
            let setfont = ":set guifont="
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
                set colorcolumn=1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,65,69,73,77,81,85,89,93,97,101
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
        map <Tab> :<C-U>MoveToNextTabStopCmd(v:count)<CR>

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
        map <S-Tab> :<C-U>MoveToPreviousTabStopCmd(v:count)<CR>
