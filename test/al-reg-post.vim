" Autoload plugin register (pre loading)
let &rtp = getcwd()

AssertEquals 'pre-value', g:testing, "Value shouldn't be changed yet"

source plugin/cachedir.vim
doautocmd BufWinEnter
Assert1 g:cachedir_loaded, "Should've loaded by now"
Assert1 g:cachedir_init_applied, "Should've applied by now"

AssertEquals 'pre-value', g:testing, "Value still not changed"

call cachedir#register('test', 'g:testing')
AssertEquals '/tmp/specific/test', g:testing, "Should've replaced by now"
