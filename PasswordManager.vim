" Password management (because pass is garbage).
" Use with an encrypted file for best security.
" Password retrieval requires that xclip be installed.
" Not compatible with non-*nix systems.
" call InitPasswordFile() to create file.
" call CreatePassword(title,username) to add a password.
" call GetPassword(title) to echo username and copy password to clipboard.

" Settings (can be altered)
    let g:passwordStrength = 50
    let g:bufferZone = 100
    " bufferZone determines how many blank lines to put after header, so it
    " doesn't show when you're using the file.

" Generate random password using urandom.
function! GeneratePassword(length)
    let dumLen = a:length
    let $cmdStr = "< /dev/urandom tr -dc 'a-zA-Z0-9~!@#$%^&*_-' | head -c".dumLen
    let $returnVal = substitute(system($cmdStr),"[[:cntrl:]]","",'g')
    return $returnVal
endfunction

" Verify that the file is a password file (so don't accidentally call functions).
function! VerifyFile()
    let testVal = match(getline(1),'^\*PASSWORDFILE\*$')
    let returnVal = (testVal != -1)
    return returnVal
endfunction

" Turn current file into a password file.
function! InitPasswordFile()
    call append('^','*PASSWORDFILE*')
    call append('1','When editing this file manually (which you may need to do on occasion), make sure you keep the format the same.')
    call append('2','This blank space is here to prevent others from seeing your passwords.')
    call append('3','Use call CreatePassword(title,username) to create a new password.')
    call append('4','Use call GetPassword(title) to copy password to clipboard.')
    call setpos('.',[0,5,0,0])
    let ind = 0
    let bufferZone = g:bufferZone-4
    while ind<bufferZone
        call append('.'," ")
        let ind+=1
    endwhile
    call setpos('.',[0,0,0,0])
endfunction

" Create a new password, based on title and username.
function! CreatePassword(title,user)
    if (!VerifyFile())
        throw "This is not a password file."
    else
        call setpos('.',[0,line('$'),0,0])
        let $pass = GeneratePassword(g:passwordStrength)
        call append('$',a:title)
        call append('$',"user:".a:user)
        call append('$',"pass:".$pass)
        call append('$','')
    endif
    call setpos('.',[0,0,0,0])
endfunction

" Get existing password.  Echo username and copy password to clipboard.
function! GetPassword(title)
    if (!VerifyFile())
         throw "This is not a password file."
    else
        call setpos('.',[0,0,0,0])
        exec "/^".a:title."$"
        if line('.')==1
            echo "Not found"
        else
            call GetPasswordIntermediate(line('.'))
            silent! setpos('.',[0,0,0,0])
        endif
    endif
endfunction

function! GetPasswordIntermediate(lineNum)
    echo getline(a:lineNum+1)
    let $password = substitute(getline(a:lineNum+2),'^.\{-}:','','')
    let $cmdDum = "echo '".$password."' | xclip -selection c"
    call system($cmdDum)
    call system('sleep 60 && echo "" | xclip -selection c &')
    call setpos('.',[0,0,0,0])
endfunction

command! -nargs=1 GP call GetPassword(<f-args>)

command! -nargs=* CP call CreatePassword(<f-args>)

command! IPF call InitPasswordFile()
