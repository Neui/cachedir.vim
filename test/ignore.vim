let g:cachedir_config = {'test': {'var': 'g:testing', 'ignore': 1}}

source plugin/cachedir.vim
doautocmd BufWinEnter

AssertEquals 'pre-value', g:testing, "Shouldn't be applied since its ignored"
