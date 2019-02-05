unlet g:cachedir_prefix
let $XDG_CACHE_HOME='/some/path'
" Just in case this is run on windows
let $TEMP=$XDG_CACHE_HOME
let $TMP=$XDG_CACHE_HOME

source plugin/cachedir.vim

AssertEquals '/some/path', g:cachedir_prefix, "Should've been changed"

