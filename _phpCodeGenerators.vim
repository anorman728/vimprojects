" Functions to generate php code.

" Source the TextManipulation plugin.
    let $currentDir=expand("<sfile>:p:h")
    let $textManipulation = $currentDir."/TextManipulation.vim"
    call SourceIfNotSourced($textManipulation)

" Set linenum variable.
    let g:linenum = 0

" Increment function.
    function! Increment()
        let g:linenum = g:linenum + 1
        return g:linenum
    endfunction

" Create getters and setters.

    " Todo: Create version of this that can accept semicolon-delimited values for multiple variables.

    " This could be done in a better way, but for the moment I just want to get it done.
    function! Capitalize(string)
        let uppercase = toupper(a:string)
        let capitalized = strpart(uppercase,0,1) . strpart(a:string,1,strlen(a:string)-1)
        return capitalized
    endfunction

    function! Getter(variable, type)
        "let uppercase = toupper(a:variable)
        "let propercase = strpart(uppercase,0,1) . strpart(a:variable,1,strlen(a:variable)-1)
        let propercase = Capitalize(a:variable)
        let currentLine = getpos('.')[1] - 1
        let g:linenum = currentLine
        call InsertLine(Increment(), "/**")
        call InsertLine(Increment(), ' * Getter for ' . a:variable . '.')
        call InsertLine(Increment(), ' *')
        call InsertLine(Increment(), ' * @access  Public')
        call InsertLine(Increment(), ' * @return  ' . a:type)
        call InsertLine(Increment(), ' */')
        call InsertLine(Increment(), 'public function get'.propercase.'(): '.a:type)
        call InsertLine(Increment(), '{')
        call InsertLine(Increment(), '   return $this->'.a:variable.';')
        call InsertLine(Increment(), '}')
    endfunction

    function! Setter(variable, type)
        let uppercase = toupper(a:variable)
        let propercase = strpart(uppercase,0,1) . strpart(a:variable,1,strlen(a:variable)-1)
        let currentLine = getpos('.')[1] - 1
        let g:linenum = currentLine
        call InsertLine(Increment(), '/**')
        call InsertLine(Increment(), ' * Setter for ' . a:variable . '.')
        call InsertLine(Increment(), ' *')
        call InsertLine(Increment(), ' * @access  Public')
        call InsertLine(Increment(), ' * @param   '.a:type.' $input')
        call InsertLine(Increment(), ' */')
        call InsertLine(Increment(), 'public function set'.propercase.'($input)')
        call InsertLine(Increment(), '{')
        call InsertLine(Increment(), '    $this->'.a:variable.' = $input;')
        call InsertLine(Increment(), '}')
    endfunction

    function! SetGet(variable, type)
        call Setter(a:variable, a:type)
        call InsertLine(getpos('.')[1], '')
        call Getter(a:variable, a:type)
    endfunction
