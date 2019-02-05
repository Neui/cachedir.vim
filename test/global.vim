let g:cachedir_config = {
			\	'test': {
			\		'var': 'g:testing',
			\		'global': 1
			\	}
			\ }

source plugin/cachedir.vim
doautocmd BufWinEnter

AssertEquals '/tmp/global/', g:testing
