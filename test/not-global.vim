let g:cachedir_config = {
			\	'test': {
			\		'var': 'g:testing',
			\	}
			\ }

source plugin/cachedir.vim
doautocmd BufWinEnter

AssertEquals '/tmp/specific/test', g:testing
