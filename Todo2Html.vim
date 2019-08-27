" Plugin that converts the todo format to html.

" As of 8/27/2019, uses TOhtml for much better results.

function! Htmlify(outputFile)
    " Note: This is absolutely terrible code.  I find myself not caring.

    " Later note:  My gosh, I sure care now.  Maybe this should have been a
    " Python script.

    " Final note:  If you think this final version is bad, you should have seen
    " the version when I made the previous note.

    set nonumber
    set norelativenumber

    TOhtml

    let lines = line('$')
    let i=1
    let $isOn = 0
    let $lineopeningregexp = '^<span.\{-}>'

    while i<=lines
        let $line = getline(i)
        let $spanstuff = matchstr($line, $lineopeningregexp)

        if match($line, '^<pre') != -1 || ($line == '</pre>')
            call setline(i, '')
        endif

        if $isOn
            if strlen($spanstuff) != 0
                let $lineDum = substitute($line, $lineopeningregexp, '', '')
            else
                " In this case, there's no existing span, thus no span to filter
                " out.
                let $lineDum = $line
            endif

            let $spaces = matchstr($lineDum, '^\s\+')
            let $spacesCount = string(strlen($spaces) / 2 + 2.5)

            " Remove extraneous space (not really necessary, but good for
            " viewing source).
            "let $line = substitute($line, '>\s\+', '>', '')
            "let $line = substitute($line, '^\s\+', '', '')
            " These cause more problems than they solve.  Just keep the extra
            " spaces in the source.  No one's going to have any reason to look
            " at it anyway.

            " Put &nbsp; in if $line is empty.
            if strlen($line) == 0
                let $line = '&nbsp;'
            endif

            let $newline = '<div style="padding-left:' . $spacesCount . 'em;text-indent:-1.25em;">' . $line . '</div>'
            call setline(i, $newline)

        endif

        if $line == '</head>'
            " Tack this on in a tackily tacky way.
            let $lineDum = '<style>div{font-size:1.75em;}</style>' . $line
            call setline(i, $lineDum)
        endif

        if $line == '<body>'
            let $isOn = 1
        elseif $line == '</body>'
            let $isOn = 0
        endif

        let i+=1

    endwhile

    let $dumvar = a:outputFile
    " I don't know why I have to do this, but I do.
    sav $dumvar
    " Note: Force saving is useful when debugging, but I don't want it in
    " practice.
    q!

    set number
    set relativenumber

    " Note: On the off-chance that anybody's reading this and actually using it,
    " sorry if you don't like these settings, but I'm feeling way too lazy right
    " now to look up whatever bizarre method vimL would need to use to set this
    " correctly.  I pretty much always have number and relativenumber set.

endfunction
