let g:cachedir_config = {
			\ '1': {'var': 'g:test1', 'prepend': 1},
			\ '2': {'var': 'g:test2', 'append': 1},
			\ '3': {'var': 'g:test3', 'prepend': 1, 'prepend-sep': '#'},
			\ '4': {'var': 'g:test4', 'append': 1, 'append-sep': '#'},
			\ '5': {'var': 'g:test5', 'append': 1, 'prepend': 1},
			\ '6': {'var': 'g:test6', 'append': 1, 'append-sep': '#',
			\ 	'prepend': 1, 'prepend-sep': '#'},
			\ }
let g:test1 = 'pre-value'
let g:test2 = 'pre-value'
let g:test3 = 'pre-value'
let g:test4 = 'pre-value'
let g:test5 = 'pre-value'
let g:test6 = 'pre-value'

source plugin/cachedir.vim
doautocmd BufWinEnter

AssertEquals '/tmp/specific/1,pre-value', g:test1
AssertEquals 'pre-value,/tmp/specific/2', g:test2
AssertEquals '/tmp/specific/3#pre-value', g:test3
AssertEquals 'pre-value#/tmp/specific/4', g:test4
AssertEquals '/tmp/specific/5,pre-value,/tmp/specific/5', g:test5
AssertEquals '/tmp/specific/6#pre-value#/tmp/specific/6', g:test6

