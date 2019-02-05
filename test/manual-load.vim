let g:cachedir_config = {
			\	'test': {
			\		'var': 'g:testing',
			\	}
			\ }
let g:cachedir_auto_apply = 0

source plugin/cachedir.vim
doautocmd BufWinEnter

AssertEquals 'pre-value', g:testing

call Cachedir_apply_userconfig()

AssertEquals '/tmp/specific/test', g:testing
