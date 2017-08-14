" Functions to generate php code.

" Create getters and setters.

    " Todo: Create version of this that can accept semicolon-delimited values for multiple variables.

    " This could be done in a better way, but for the moment I just want to get it done.
    function! Capitalize(string)
        let uppercase = toupper(a:string)
        let capitalized = strpart(uppercase,0,1) . strpart(a:string,1,strlen(a:string)-1)
        return capitalized
    endfunction

    function! Getter(variable)
        "let uppercase = toupper(a:variable)
        "let propercase = strpart(uppercase,0,1) . strpart(a:variable,1,strlen(a:variable)-1)
        let propercase = Capitalize(a:variable)
        exe ":normal i" . ("public function get".propercase."(){")
        exe ":normal o"
        exe ":normal i" . ("    return $this->".a:variable.";")
        exe ":normal o"
        exe ":normal i" . ("}")
        exe ":normal o"
        exe ":normal o"
    endfunction

    function! Setter(variable)
        let uppercase = toupper(a:variable)
        let propercase = strpart(uppercase,0,1) . strpart(a:variable,1,strlen(a:variable)-1)
        exe ":normal i" . ("public function set".propercase."($input){")
        exe ":normal o"
        exe ":normal i" . ("    $this->".a:variable." = $input;")
        exe ":normal o"
        exe ":normal i" . ("}")
        exe ":normal o"
        exe ":normal o"
    endfunction

    function!  GetSet(variable)
        call Getter(a:variable)
        call Setter(a:variable)
    endfunction
