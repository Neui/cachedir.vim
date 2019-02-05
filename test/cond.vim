let g:cachedir_config = {'test': {'var': 'g:testing', 'cond': 'g:test == 0'}}
let g:test = 1

source plugin/cachedir.vim
doautocmd BufWinEnter

AssertEquals 'pre-value', g:testing, "condition was false"

let g:test = 0
call Cachedir_apply_userconfig()

AssertEquals '/tmp/specific/test', g:testing, "condition was true"

