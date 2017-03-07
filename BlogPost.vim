" Functions to quickly convert pseudo-html to commonly-used html tags.  (For Wordpress, this is a little easier to set up than CSS classes.)

function! BlogConvert()
    " Get cursor position
        let cursor = getpos('.')
    " Replace <code>
        let $style = 'font-family:\ monospace;\ background-color:\ #eeeeee;'
        let $replace = '<span\ style="'.$style.'">'
        silent exec '%s/<code>/'.$replace.'/g'
    " Replace </code>
        silent exec '%s/<\/code>/<\/span>/g'
    " Reset cursor position
        call setpos('.',cursor)
endfunction
