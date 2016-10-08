set nocompatible
"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
behave xterm
" Updated: 10/7/2016 10:19 AM
 
" Notes:
"   TODO: Organize the notes section, probably delete or archive some.
 
"   Fix "Not an editor command: ^M" message with :w ++ff=unix
"   Logging messages.
"       Can log messages with "echom" instead of "echo."  If use "echom", then
"         can see log of messages when type in ":messages".  (This is invaluable
"         for debugging.)
"   Setting up conflict management:
"       Use "set diff" and "set scrollbind" on each window to compare two files
"         for conflict management.
"   Registry management:
"       Reference whatever is in the latest register with @, like "let
"       $myVar=@".
"       Reference whatever is in the OS clipboard with @*, like "let $myVar=@*".
"       See all registers with ":reg".
"       Paste something in register X with this, and note that the quote in
"       front of the X is there on purpose.
"           "Xp
"       Likewise, put something into register X with something like "Xy or "Xd,
"       etc.
"   Dealing with directories/filenames:
"       Can set variables to these, i.e.,
"           let $myVar = expand('%:p')
"       Current file's path:
"           expand('%:p')
"       Current file's directory's path:
"           expand('%:p:h')
"       Current file's name:
"           expand('%:t')
"       Current file's extension:
"           expand('%:e')
"       This is useful for managing multiple files at once, either in different
"         tabs or in different windows.
"   Managing tabs:
"       tabe <filename>
"           Open new tab with <filename>
"       <#>gt
"           Switch to tab number <#>
"       tabm <#>
"           Move current tab to this position number <#> (starts at 0).
"       tabm
"           Move current tab to end.
"   Sessions:
"       Make a session with ":mksession <filename>.vim"
"       Restore a session with ":source <filename>.vim"
"   Delete all trailing whitespace with ":%s/\s\+$//"
"   Point vimrc file towards this file, i.e., 
"        let $VIMDROPBOX = '/home/andrew/Dropbox/vim/_vimDropbox.vim'
"        source $VIMDROPBOX
"
"   Use ":set syntax=vim" to enable syntax highlighting for vim files like this
"     one if it doesn't already have a *.vim extension.
"   Use ":source $MYVIMRC" to reload vimrc without having to reload the whole
"     program.
"   Use ":scriptnames" to view which scripts are currently being used.
"   Use ":call" to use functions, like ":call CustomColumns()"
"   Manually set syntax to bash with ":syntax=sh", and to vim with
"     ":syntax=vim".
"   Open existing file with e command.
"   Use as file explorer by "opening" a directory, i.e., "e ." opens the
"     explorer on the current directory.
"       Open whatever's under the cursor with "gf".
"   Can use some bash commands like pwd, cd, etc.
"   Edit vimrc quickly with e $MYVIMRC.  Need to have vim open in su/admin to
"     make changes.
"   Use ls to list all files in the buffer.  (They're not actually still open,
"     but more of a "recent files" type of thing.)  Use bX to switch to document X
"     as listed there.  (Can also use n, bn, p, and bp to navigate.)
"   When copying from email, this gets double-spaced.  Get back to normal with
"     :g/^$/d
"   Search multiple files with 'vimgrep /<regex here>/gj **/*.txt' (lvimgrep is
"     similar, but doesn't save list)
"       This stores the file list in a buffer which can be open "copen".  gf can
"         be used to open the file under the cursor.
"   Delete all lines that contain a flag with g/<flag>/delete, i.e.,
"     g/\/\/\~/delete to delete all lines that contain //~.
"   Reload previously used visual block with gv.
 

" Settings

    " set $VIMDROPBOX to this file.

        let $VIMDROPBOX = expand("<sfile>")

    " Set font.
        if has("unix")
            set guifont=Monospace\ 13 " Linux
        else
            set guifont=Courier\ New:h12 " Windows
        endif
        
    " Set color scheme
        colorscheme koehler
        " Changing the background color of folded lines is done in the "syntax
        " on" segment.
        
    " Show line numbers
        set number
        
    " Shown on breaks if wordwrap is on.
        if has("patch1-712")
            set breakindent
            set showbreak=\ 
        else 
            set showbreak=\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ >>
        endif
        "set showbreak=>>

    " When textwidth is nonzero, don't add line breaks-- Prefer to do that with
    "   Rewrap.
    " set formatoptions=t to change this back to automatically break lines while
    " writing.
    " Also, don't add stupid things to the lines like asterisks.  Prefer to do
    "   that manually.
        set formatoptions=
        
    " Don't break lines in the middle of words in wordwrap.
        set lbr
     
    " Use spaces instead of tabs.
        set tabstop=4 shiftwidth=4 expandtab
     
    " Indent folding
        set foldmethod=indent
        set foldlevel=99
     
    " Put swap file, etc. into temporary directory instead of the current
    " directory.
        if has("unix")
            if exists('isAndroid') && isAndroid==1
                let $backupdir="/storage/emulated/0/vimtmp" " Android
            else
                let $backupdir="/tmp" " Linux
            endif
        else
            let $backupdir="C:\\Temp" " Windows
        endif

        if isdirectory($backupdir)
            set backup backupdir=$backupdir dir=$backupdir
        else
            echom "Warning: ".$backupdir." not found for swap files."
            let $dumvar=input("Press enter to acknowledge.")
        endif
        
    " Sometimes Vim doesn't automatically use color-coding.  This forces it.
    " (Also make sure to use opening tags in php.)
        syntax on
        hi Folded guibg='Black'
            " Removes background highlighted from folded lines. (Because they're
            "   kind of annoying.)
            " Need to do this *here* rather than when setting color scheme because
            "   "syntax on" will change it back.
        
    " Disables automatic formatting, but I'm not certain that it's necessary in
    "   light of the autoindent section below.  Commented out for now.
        "autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
     
    " Automatically indent new line based on the current line's indentation.
        set indentexpr= "Autoindent alone doesn't do it for some reason.
        set autoindent
        
    " Set backspace behavior.
        " :set backspace=indent,eol,start " The way backspace works in most
        "   programs-- Can backspace over autoindent, line breaks, where cursor was
        "   when entered insert mode.
        ":set backspace= " Default for Vim-- Cannot do any of the three listed above.
        set backspace=start,indent

    " Lower-right corner always shows line and column that cursor is currently on.
        set ruler

    " Set non-case sensitive

        set ic

    " Set virtual edit to block-- That way it doesn't skip blank lines.  With this
    "   enabled, can use append or replace (but not insert) to correctly add
    "   asterisks to blank lines in docblocks.

        "set ve=block
        set ve=all " This way, can go past the actual end of the line (which makes lining up equals signs, etc., easier).

    " Disable "startofline" to preserve current column when switching to a new line.

        set nostartofline

    " Disable word wrap

        set nowrap

    " Relative number
        
        set relativenumber

    " Textwidth
        
        set textwidth=80

" Other scripts to load.  (Must be in same directory as this file.)

    let $currentDir=expand("<sfile>:p:h")

    let $lineup = $currentDir."/Lineup.vim"
    source $lineup

    let $rewrap = $currentDir."/Rewrap.vim"
    source $rewrap

    let $customFunctions = $currentDir."/CustomFunctions.vim"
    source $customFunctions

    let $foldModifiedIndent = $currentDir."/foldModifiedIndent.vim"
    source $foldModifiedIndent

