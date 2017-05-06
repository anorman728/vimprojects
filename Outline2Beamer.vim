" Plugin that converts todo format to Beamer.
" Using '~' for home directory in *NIX doesn't work at the moment.

" DO NOT ESCAPE SPACES IN FILE NAMES!

" Source the TextManipulation plugin.
    let $currentDir=expand("<sfile>:p:h")
    let $textManipulation = $currentDir."/TextManipulation.vim"
    call SourceIfNotSourced($textManipulation)

" Set pause variable.
    let $pause = '\pause'

" Converts todo format to Beamer format.
" First argument is the output file path.
" Second (optional) argument is author name.
" TODO: Actually run the pdflatex command.

function! Beamerify(outputFile,...)

    " Manage arguments
        let outputFile = a:outputFile
        if (!exists('a:1'))
            let authorName=""
        else
            let authorName = a:1
        endif

    call InitializeFile(outputFile)

    let $lineDum = LatexHeader()
    call AppendToFile(outputFile,$lineDum)

    " Title
        let $lineDum = substitute(getline(1),'^\s\+\*\(\s\+\)\?','','')
        call AppendToFile(outputFile,'\title{'.$lineDum.'}')
    
    " Author
        let $lineDum = InjectString('\author{${1}}',authorName)
        call AppendToFile(outputFile,$lineDum)

    " Beginning of document.
        let $lineDum = '\begin{document}'.$newline
        let $lineDum.= '\maketitle'
        call AppendToFile(outputFile,$lineDum)

    " Begin first frame.
        let $lineDum = '\begin{frame}'
        call AppendToFile(outputFile,$lineDum)
        
    " Move through rest of file.
        let lines = line('$')
        let i=2
        "Start on second line because first is title.
        while i<=lines
            let $lineDum = LatexBody(i)
            call AppendToFile(outputFile,$lineDum)
            let i += 1
        endwhile

    " End last frame
        let $lineDum = '\end{frame}'
        call AppendToFile(outputFile,$lineDum)

    " End document
        let $lineDum = '\end{document}'
        call AppendToFile(outputFile,$lineDum)

    call FinalizeFile(outputFile)

endfunction

function! LatexHeader()
    let $returnStr = ""
    let $returnStr .= '\documentclass[aspectratio=169]{beamer}'.$newline
    let $returnStr .= '\usepackage{amssymb}'.$newline
    let $returnStr .= '\usepackage{amsthm}'.$newline
    let $returnStr .= '\usepackage{amsmath}'.$newline
    let $returnStr .= '\makeatletter'.$newline
    let $returnStr .= '\makeatother'.$newline
    let $returnStr .= '\lefthyphenmin=64'.$newline
    let $returnStr .= '\raggedright'
    return $returnStr
endfunction

"Intermediate function for slideshow based on lines.
" TODO: pic to pull in a picture.
" TODO: httpic to pull in picture from internet.
function! LatexBody(i)
    let $lineDum = substitute(getline(a:i),'^\(\s\+\)\?','','')
    " Skip blank lines.
        let $blankLine='^\(\s\+\)\?$'
        if match($lineDum,$blankLine)!=-1
            return ""
        endif
    " Get current indent level.
        let $currentIndent = ModifiedIndentLevel(a:i)
        let $indentDum=MultiplyString("    ",$currentIndent)
    " Set output string to blank (for concatenations later)
        let $returnStr = ""
    " Change comment to LaTex comment.
        let $commentLine='^\/\/'
        if match($lineDum,$commentLine)!=-1
            return $returnStr
        endif    
    " Create title if no indent level.
        if $currentIndent == 0
            if a:i!=2
                let $dumStr01 = '\end{frame}'.$newline.$newline
                let $dumStr02 = '\begin{frame}'.$newline
            else
                let $dumStr01 = ''
                let $dumStr02 = ''
            endif
            let $dumStr03 = InjectString('\frametitle{${1}}',$lineDum)
            return $dumStr01.$dumStr02.$dumStr03
        endif
    " Create item
        " Increase indent, if necessary.
            let $returnStr = $returnStr.BeginItemize(a:i)
        " Create item.
            let $returnStr = $returnStr.$indentDum.InjectString('\item ${1}',$lineDum).$pause
        " Decrease indent, if necessary.
            let $returnStr = $returnStr.$newline.EndItemize(a:i)
        " Return
            return $returnStr
endfunction

function! BeginItemize(lineNum)
    " Get indent levels
        let $prevIndent = PrevIndent(a:lineNum)
        let $currentIndent = ModifiedIndentLevel(a:lineNum)
        let $indentDum=MultiplyString("    ",$currentIndent)
    if $prevIndent < $currentIndent
        let $returnVal = $indentDum.'\begin{itemize}'.$newline
    else
        let $returnVal = ''
    endif
    return $returnVal
endfunction

function! EndItemize(lineNum)
    " Get indent levels
        let $nextIndent = NextIndent(a:lineNum)
        let $currentIndent = ModifiedIndentLevel(a:lineNum)
    if $nextIndent < $currentIndent
        let stepMax = $currentIndent - $nextIndent
        let i = 0
        let $returnVal = ""
        while i<stepMax
            let $returnVal .= MultiplyString("    ",($currentIndent-i)).'\end{itemize}'.$newline
            let i+=1
        endwhile
    else
        let $returnVal = ''
    endif
    return $returnVal
endfunction

function! NextIndent(lineNum)
    let i = a:lineNum+1
    let $lineDum1 = getline(i)
    let $regex = '^\(\s\+\)\?\/\/'
    while match($lineDum1,$regex)!=-1
        let i += 1
        let $lineDum1 = getline(i)
    endwhile
    return ModifiedIndentLevel(i)
endfunction

function! PrevIndent(lineNum)
    let i = a:lineNum-1
    let $lineDum1 = getline(i)
    let $regex = '^\(\s\+\)\?\/\/'
    while match($lineDum1,$regex)!=-1
        let i -= 1
        let $lineDum1 = getline(i)
    endwhile
    return ModifiedIndentLevel(i)
endfunction
