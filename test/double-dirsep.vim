let g:cachedir_config = {
			\ '1': {'var': 'g:test1', 'pre': 'PRE'},
			\ '2': {'var': 'g:test2', 'suf': 'SUF'},
			\ '3': {'var': 'g:test3', 'pre': 'PRE', 'suf': 'SUF'},
			\ }
let g:test1 = 'pre-value'
let g:test2 = 'pre-value'
let g:test3 = 'pre-value'

source plugin/cachedir.vim
doautocmd BufWinEnter

AssertEquals 'PRE/tmp/specific/1', g:test1, "Prefix only"
AssertEquals '/tmp/specific/2SUF', g:test2, "Suffix only"
AssertEquals 'PRE/tmp/specific/3SUF', g:test3, "Prefix and suffix"
