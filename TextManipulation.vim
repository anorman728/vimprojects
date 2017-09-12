" Functions used in plugins for text manipulation (like Todo2Html).

if has('unix')
    let $newline = "\n"
else
    let $newline = "\r\n"
endif

" Create shortcut to insert/append value in variable.

    function! Insert(input)
        let $indenttype = GetOutput("set autoindent?")
        set noautoindent
        exe ":normal i".a:input
        silent exec "set ".$indenttype
    endfunction
    
    function! Append(input)
        exe ":normal a".a:input
    endfunction

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
" outputFile is not *currently* being used for anything, but here in case anything
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
    function! AppendToFile(file, message)
        " Note: Don't debug this with the Debug function.  Causes infinite recursion.
        if !has('Unix')
            echo "Warning:  This will not be compatible with non-Unix-like systems."
        endif
        let lineArr = split(a:message, '\n')
        for msg in lineArr
            let $cmd = '! echo "'.msg.'" >> '.a:file
            silent exec $cmd
        endfor
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

" Get the word under the specified line and column.
" "Word", here, is specifically defined as the regex acceptableCharacterReg
    function! GetWordInPosition(line, col, acceptableCharacterReg)
        " Get position of start of word
        let startposition = GetStartOfWord(a:line, a:col, a:acceptableCharacterReg)

        " Get position of end of word.
        let endposition = GetEndOfWord(a:line, a:col, a:acceptableCharacterReg)

        return strpart(getline(a:line), startposition - 1, endposition - startposition + 1)
    endfunction

" Get the character in the specified line and column.
    function! GetCharacterInPosition(line, col)
        return strpart(getline(a:line),a:col-1,1)
    endfunction

" Get position of start of a word in the document.
" Here, "word" is defined specifically by acceptable character regex.
    function! GetStartOfWord(line, col, acceptableRegex)
        let startPos = a:col
        while (startPos > 0 && match(GetCharacterInPosition(a:line, startPos), a:acceptableRegex) != -1)
            let startPos -= 1
        endwhile
        return startPos + 1
    endfunction

" Get position of end of a word in the document.
" Here, "word" is defined specifically by acceptable character regex.
    function! GetEndOfWord(line, col, acceptableRegex)
        let endPos = a:col
        while (match(GetCharacterInPosition(a:line, endPos), a:acceptableRegex) != -1)
            let endPos += 1
        endwhile
        return endPos - 1
    endfunction

" Replace substring based on position, rather than regex.
    function! SubstringReplace(exp, sub, startpos, length)
        let startpos = a:startpos
        return strpart(a:exp, 0, startpos).a:sub.strpart(a:exp, startpos + a:length)
    endfunction

" Test if value is a numeric integer (whether it has commas or not).
" Does not detect comma misplacement, i.e., 12,34 will return true.
    function! IsInt(inputStr)
        if (strlen(a:inputStr) == 0)
            return 0
        endif
        let $testRegex = '\(\(\d\|,\|\s\)\@!.\)'
        " Above regex finds anything that's neither a number nor a comma.
        return (match(a:inputStr, $testRegex) == -1)
    endfunction

" Insert line above the specified line number.
" IF CREATES
    function! InsertLine(linenum, linestr)
        call setpos('.', [0, a:linenum, 0, 0])
        exec "normal O"
        call setline(a:linenum, a:linestr)
        call setpos('.', [0, a:linenum+1, 0, 0])
    endfunction

" Dealing with numbers
    " Add or remove commas from number under cursor.
    " Displays error message if a number is not under the cursor.
    function! AddOrRemoveCommasFromNumberUnderCursor()
        let posArr = getpos('.')
        let $testWord = GetWordInPosition(posArr[1],posArr[2],'\d\|,')
        if (!IsInt($testWord))
            echo "Word under cursor is not a number."
        else
            call AddOrRemoveCommasFromNumberUnderCursorIntermediate()
        endif
    endfunction

    command! Commas call AddOrRemoveCommasFromNumberUnderCursor()

    " Add or remove commas from number under cursor.
    " Intermediate function, which does not check for invalid cursor position.
    function! AddOrRemoveCommasFromNumberUnderCursorIntermediate()
        let posArr = getpos('.')
        let $regex = '\d\|,'
        let $numberStr = GetWordInPosition(posArr[1],posArr[2],$regex)
        if (match($numberStr, ',') == -1)
            let $newNumber = AddCommasToNumber($numberStr)
        else
            let $newNumber = RemoveCommasFromNumber($numberStr)
        endif
        let startPos = GetStartOfWord(posArr[1], posArr[2], $regex)
        let endPos = GetEndOfWord(posArr[1], posArr[2], $regex)
        let $newline = SubstringReplace(getline(posArr[1]), $newNumber, startPos - 1 , endPos - startPos + 1)
        call setline(posArr[1],$newline)
    endfunction

    " Add commas to number.  (Note that the input will need to be passed as a
    " string, because Vim has a very small resolution for integers.)
    function! AddCommasToNumber(inputNum)
        let numStr = a:inputNum
        let length = strlen(numStr)
        let firstCommaDone = 0
        let i = length - 2
        let outputNum = numStr
        while (i>0)
            if ((length - i) % 3 == 0)
                let outputNum = strpart(outputNum,0,i).','.strpart(outputNum,i)
            endif
            let i -= 1
        endwhile
        return outputNum
    endfunction

    " Remove commas from number.
    function! RemoveCommasFromNumber(inputNum)
        return substitute(a:inputNum,',','','g')
    endfunction

" Get selected text.
" Yanked from https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript#6271254
" This can be used in functions, but can rarely be called directly, i.e.,
" let $a=GetVisualSelection(), if called directly by user, will throw a "No
" range allowed" error.
function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" Remove spaces at the ends of lines

function! RemoveSpaces()
    %s/\(\s\|\s\+\)$//
endfunction


" Determine if a file exists or not.

function! FileExists(filePath)
    if !has('Unix')
        echo "Warning:  This will not be compatible with non-Unix-like systems."
    endif
    let $filePath = fnameescape(a:filePath)
    let $testCmd = 'if [[ -s '.a:filePath.' ]]; then echo "1"; else echo "0"; fi;'
    let returnVal = substitute(system($testCmd), '[[:cntrl:]]', '', 'g')
    return returnVal
endfunction
