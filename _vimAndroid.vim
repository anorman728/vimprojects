" Commands for vim on Android.
let $VIMANDROID = expand('%:p')
let $root = '/storage/emulated/0/'
let $dropsync = $root .'DropsyncFiles/'
cd $dropsync
let isAndroid=1
let $temp=$dropsync.'_vimDropbox.vim'
source $temp
let $VIMDROPBOX=$temp " '%:p' returns the calling script on Android.
