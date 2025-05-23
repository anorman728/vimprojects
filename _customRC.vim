set nocompatible
behave xterm
" Updated: 04/30/2017

" Notes:

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
"   Sessions:
"       Make a session with ":mksession <filename>.vim"
"       Restore a session with ":source <filename>.vim"
"   Use ":scriptnames" to view which scripts are currently being used.
"   Delete all lines that contain a flag with g/<flag>/delete, i.e.,
"     g/<regex>/delete to delete all lines that contain match for <regex>
"   If messed up decrypt key, can retry with two commands: set key=;edit (need to be on separate lines)
"   Reload all files in buffer with "buffdo e".
"   Netrw functions:
"       Most Netrw functions are listed on screen.  Some aren't.
"       d = create new directory.
"       % = create new file.
"   Remove "control" characters (those annoying things that start with ^) with [[:cntrl:]]

"   Default settings are usually in /usr/share/vim/vim74/ (or another number for a different version)

"   Use "=" to automatically set spacing according to current syntax.

"   Use command TOhtml (can be used with highlighted code) to generate HTML text of code.

"   Use `set optionname?` to see current value of option name. (like `set ic?`)
"   Use `verbose set optionname?` to see the value and what script last set it.

"   Note on folding:  If your fold method is expr and you switch to manual, the
"   foldlevel of each line that was set by expr is not changed.  That means you
"   can change to manual fold level without losing any existing folds (whether
"   opened or closed) and create new folds.  (This is really useful when need to
"   fold something with bad indentation.)
"   Create a fold in manual mode with zf, and destroy it with zd or zD to delete
"   recursively.

" Non-greedy match in Vim regex is .\{-}

" To ignore all whitespace in vim diff, `set diffopt+=iwhite`.

" Setting a file's syntax from within the file requires putting what's called a
" "modeline" on the first line-- `# vi:syntax=php`

" If you see the [1]+ Stopped nonsense, the command "fg" should get back into
" vim.

" Actually, not much nonsense when you don't have GNU Screen available and it's
" kind of cool then, and you can do it with Ctrl+Z.

" The one thing that consistently fixes bad syntax highlighting due to folding
" when nothing else works is :syn sync fromstart, but it apparently slows Vim
" down quite a bit.

" To backspace past newlines (useful in Termux), `set backspace+=eol`.


" Settings

    " set $CUSTOMRC to this file.

        let $CUSTOMRC = expand("<sfile>")

    " Set font.
        if has("unix")
            set guifont=Monospace\ 13 " Linux
        else
            set guifont=Consolas:h12 " Windows
        endif

    " Set color scheme
        colorscheme koehler
        " Changing the background color of folded lines is done in the "syntax
        " on" segment.

    " Show line numbers
        set number

    " Shown on breaks if wordwrap is on.
        set breakindent
        set showbreak=\ \ 
        "set showbreak=>>

    " Don't add stupid things to the lines like asterisks.  Prefer to do
    "   that manually.
        set formatoptions=

    " Don't break lines in the middle of words in wordwrap.
        set lbr

    " Use spaces instead of tabs.
        set tabstop=4 shiftwidth=4 expandtab

    " Put swap file, etc. into temporary directory instead of the current
    " directory.
        "if has("unix")
        "    if exists('isAndroid') && isAndroid==1
        "        let $backupdir="/storage/emulated/0/vimtmp" " Android
        "    else
        "        let $backupdir="/tmp" " Linux
        "    endif
        "else
        "    let $backupdir="C:\\Temp" " Windows
        "endif

        let $backupdir = $HOME.'/backupdir'

        if isdirectory($backupdir)
            set backup backupdir=$backupdir dir=$backupdir
        else
            echom "Warning: ".$backupdir." not found for swap files."
            let $dumvar=input("Press enter to acknowledge.")
        endif

    " Disable temporary files (if they cause more problems than they solve).
        "set nobackup
        "set noswapfile

    " Sometimes Vim doesn't automatically use color-coding.  This forces it.
    " (Also make sure to use opening tags in php.)
        syntax on

    " Removes background highlighted from folded lines. (Because they're
    "   kind of annoying.)
    " Need to do this *here* rather than when setting color scheme because
    "   "syntax on" will change it back.
        hi Folded ctermbg=0

    " Darken text of folded lines so they don't get in the way.
        "hi Folded ctermfg=Black
        hi Folded ctermbg=Black

    " Misc color settings for terminal.
        " Remove weird colors for errors.
        hi Error ctermbg=0
        hi Error ctermfg=1
        " Change some colors to orange.
        hi Special ctermfg=3
        hi Identifier ctermfg=3
        hi Function ctermfg=LightYellow

    " Change the way folded lines look.
        " Yanked and modified from here-- https://stackoverflow.com/questions/33281187/how-to-change-the-way-that-vim-display-those-collapsed-folded-lines#33281531
        function! MyFoldText()
            let nblines = v:foldend - v:foldstart + 1
            let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
            let line = getline(v:foldstart)
            let leftMarginCount = match(line, '\s\@!') - 1
            let leftMargin = repeat(" ", leftMarginCount)
            let rightMargin = repeat(" ", w)
            let txt = leftMargin . " +-- " . nblines . " lines hidden --+ " . rightMargin
            return txt
        endfunction
        set foldtext=MyFoldText()

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

    " Don't write netrwhist file.

        let g:netrw_dirhistmax = 0

    " Set encryption method to blowfish2.
        set cm=blowfish2

    " Highlight ES6 template strings
        hi link javaScriptTemplateDelim String
        hi link javaScriptTemplateVar Text
        hi link javaScriptTemplateString String

    " Don't interrupt with --MORE-- prompt
        set nomore

    " Remove gui toolbar from gvim (because I never use it).
        set guioptions-=T

    " Remove search highlighting
        set nohls

    " Use F5 to resource vimrc.

        if !exists("*ResourceVimrcFunc")
            function ResourceVimrcFunc()
                source $HOME/.vimrc
            endfunction

            command! ResourceVimrc call ResourceVimrcFunc()
        endif

    " Disable the backtick shortcuts.
        " nnoremap ` <nop>
        " Disabling this because, although the backtick shortcuts are really
        " frustrating for file shortcuts, they're really useful for bookmarks
        " within a single file.

    " Disable recording file marks to viminfo.
        " This prevents vim from saving "file marks" which are *far* too easy to accidentally trigger.
        set viminfo='0,f0

" Macros
    " Use @l to replace space after cursor with underscore and capitalize
    " current word.
        let @l = "/\\ \nr_gUaw"

    " Use @d to delete everything in a file.
        let @d = "ggdG"

" Other scripts to load.  (Must be in same directory as this file.)

    let $currentDir=expand("<sfile>:p:h")

    let $lineup = $currentDir."/Lineup.vim"
    source $lineup

    let $customFunctions = $currentDir."/customFunctions.vim"
    source $customFunctions

    let $docblockTools = $currentDir."/DocblockTools.vim"
    source $docblockTools

    let $deobfuscate = $currentDir."/Deobfuscate.vim"
    source $deobfuscate

    let $modifiedIndent = $currentDir."/foldModifiedIndent.vim"
    source $modifiedIndent

    let $Todo2Html = $currentDir."/Todo2Html.vim"
    source $Todo2Html

    let $Outline2Beamer = $currentDir."/Outline2Beamer.vim"
    source $Outline2Beamer

    let $PasswordManager = $currentDir."/PasswordManager.vim"
    source $PasswordManager

    let $textManipulation = $currentDir."/TextManipulation.vim"
    source $textManipulation

    let $Mappings = $currentDir."/Mappings.vim"
    source $Mappings

    let $FileList = $currentDir."/FileList.vim"
    "call SourceIfNotSourced($FileList)
    " Don't resource this if already sourced, because causes problems if vimrc is reloaded on each file.
    " Commenting this out because I never use it.

    let $LineHighlighting = $currentDir."/LineHighlighting.vim"
    source $LineHighlighting

    " Sandbox to quickly and easily open and source scripts.  Does not matter if
    " already exists, as long as the location is writeable.
    let $sandBox = $backupdir."/sandbox.vim"

    " Use line numbers in Netrw
    let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro rnu'

    " Always show tabline.
    set showtabline=2

" Plugins not to be loaded every time vim loads.

    " Custom JSDoc
    let $jsdoc = $currentDir."/JSdoc.vim"

    " PHP Code Generators.
    let $phpCodeGenerators = $currentDir."/_phpCodeGenerators.vim"

    " Debugging tools
    let $debugTools = $currentDir."/Debug.vim"
