" Plugin that converts the todo format to html, and includes a reference to
" the MathJax script.

" Todo: Incorporate examples, using pre tags.  (Although this is geared for math, this could be useful for numerical analysis.)

function! Htmlify(outputFile)
    
    let $html = HtmlHeader()

    let lines = line('$')
    let i=1
    let prevLn = 1
    while i<=lines
        let $lineDum = substitute(getline(i),'^\s\+','','g')
        if match($lineDum,'^\(\s\+\)\?\(Example\|Ex\):\(\s\+\)\?$')!=-1
            let exampleArray = GetExampleArray(i)
            let $html .= exampleArray[0]
            let i = exampleArray[1]
        elseif match($lineDum,'^\(\s\+\)\?$')==-1
            let $html.="\r"
            " Tags
                let tags = Tags($lineDum)
            " Add blockquotes
                let $html .= AddBlockQuote(i,prevLn)
            " HtmlEntities
                let $lineDum = HtmlEntities($lineDum)
            " Underlining
                let $lineDum = AddUnderlineTags($lineDum)
            let $html .= tags[0].$lineDum.tags[1]
            let prevLn = i
        endif
        let i +=1
    endwhile

    let $html .= "\r</body>"

    if writefile([$html],a:outputFile)
        echomsg "write error"
    endif

endfunction

function! HtmlEntities(inputStr)
    let $returnVal = a:inputStr
    let $returnVal = substitute($returnVal,'&','\&amp;','g')
    let $returnVal = substitute($returnVal,'<','\&lt;','g')
    let $returnVal = substitute($returnVal,'>','\&gt;','g')
    return $returnVal
endfunction

function! HtmlHeader()
    let $html  = "\r<!DOCTYPE html>"
    let $html .= "\r<head>"
    let $html .= "\r<title>".expand('%:t')."</title>"
    let $html .= "\r<script src='https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML'></script>"
    let $html .= "\r</head>"
    let $html .= "\r<body>"
    return $html
endfunction

function! Tags(inputStr)

    if match(a:inputStr,'^>')!=-1
        " Todo.
        let $openTag = '<p style="color:green;">'
        let $closeTag = '</p>'
    elseif match(a:inputStr,'^+')!=-1
        " Done.
        let $openTag = '<p style="color:tan;">'
        let $closeTag = '</p>'
    elseif match(a:inputStr,'^\.\.\.')!=-1
        " Wait.
        let $openTag = '<p style="color:purple;">'
        let $closeTag = '</p>'
    elseif match(a:inputStr,'^\*')!=-1
        " Information.
        let $openTag = '<p style="color:blue;">'
        let $closeTag = '</p>'
    elseif match(a:inputStr,'^-')!=-1
        " Canceled
        let $openTag = '<p style="color:red;">'
        let $closeTag = '</p>'
    elseif match(a:inputStr,'^?')!=-1
        " Question
        let $openTag = '<p style="color:brown;">'
        let $closeTag = '</p>'
    elseif match(a:inputStr,'^!')!=-1
        " Important
        let $openTag = '<p style="color:brown;">'
        let $closeTag = '</p>'
    elseif match(a:inputStr,'^.*:$')!=-1
        " Title.  (Intentionally doing this last.)
        let $openTag = "<h4>"
        let $closeTag = "</h4>"
    else
        " Everything else
        let $openTag = '<p>'
        let $closeTag = '</p>'
    endif

    let returnArr = [$openTag,$closeTag]
    return returnArr
endfunction

function! AddBlockQuote(lnNum,prevLn)
    if indent(a:lnNum)>indent(a:prevLn)
        return "<blockquote>\r"
    elseif indent(a:lnNum)<indent(a:prevLn)
        let $returnVal = ''
        let closes = indent(a:prevLn)/&shiftwidth-indent(a:lnNum)/&shiftwidth
        let j = 0
        while j< closes
            let $returnVal .="\r</blockquote>"
            let j+=1
        endwhile
        return $returnVal
    else
        return ""
    endif
endfunction

function! AddUnderlineTags(lineInput)
    let $returnVal = a:lineInput
    let switch = 1
    while match($returnVal,'`')!=-1
        if switch
            let $replaceVal = "<u>"
        else
            let $replaceVal = "</u>"
        endif
        let $returnVal = substitute($returnVal,'`',$replaceVal,'')
        let switch = !switch
    endwhile
    return $returnVal
endfunction

function! GetExampleArray(lineNum)
    let $returnStr = '<pre>'
    let currLineNum = a:lineNum+1
    let currLineStr = getline(currLineNum)
    while match(currLineStr,'^\(\s\+\)\?endex')==-1
        let $returnStr .= "\r".currLineStr
        let currLineNum+=1
        let currLineStr = getline(currLineNum)
    endwhile
    let $returnStr .= "</pre>"
    return [$returnStr,currLineNum]
endfunction
