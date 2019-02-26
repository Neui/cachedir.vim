let g:cachedir_config = {
			\	'test': {
			\		'var': 'g:testing',
			\		'global': 1,
			\		'mkdir': 1,
			\	}
			\ }

let g:cachedir_prefix = '/tmp/cachedir-test-' . getpid()
let g:dir = g:cachedir_prefix . '/global/'
" Make sure the folder doesn't exist yet
if !empty(glob(g:dir))
	if delete(g:dir, 'rf') != 0
		Echof "Couldn't really delete temp directory %s", g:dir
		Echo "Test might not be correct!"
	endif
endif

source plugin/cachedir.vim
doautocmd BufWinEnter

AssertEquals g:dir, g:testing, "Other test should've failed"
AssertEquals 1, isdirectory(g:dir) . '/global/'
