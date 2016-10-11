" Maps F4 to the linup command, which lines up assignments based on the "=" character.
" You can change to a different character using the SetLineupCharacter function.

function! SetLineupCharacter(lineupCharacter)
    let g:lineupCharacter = a:lineupCharacter
endfunction

function! GetLineupCharacter()
    return g:lineupCharacter
endfunction

function! LineupFunc() range
    let maxcol = 0
    " Find the rightmost instance of g:lineupCharacter.
        for i in range(a:firstline,a:lastline)
            call setpos('.',[0,i,0,0])
            exe ":normal /".g:lineupCharacter."\<CR>"
            let coltempArr = getpos('.')
            if coltempArr[1] == i
                let coltemp = coltempArr[2]
                if coltemp>maxcol
                    let maxcol = coltemp
                endif
            endif
        endfor
    " Find the next tabstop.
        let tempInt = maxcol%4
        if tempInt==1
            let newcol = maxcol
        else
            let newcol = maxcol + 4 - tempInt
        endif
        " Todo: Test this by making sure that the results end up lining up with
        "   the colored columns from TC()
    " Add spaces to each instance until it matches up.
        for i in range(a:firstline,a:lastline)
            call setpos('.',[0,i,0,0])
            exe ":normal 0/".g:lineupCharacter."\<CR>"
            let coltempArr = getpos('.')
            if coltempArr[1] == i
                let coltemp = coltempArr[2]
                for j in range(0,newcol-coltemp-1)
                    exe ":normal i "
                endfor
            endif
        endfor
endfunction

command! -range Lineup <line1>,<line2>call LineupFunc()
map <F4> :Lineup<CR>

" Default lineup character:
    call SetLineupCharacter('=')
