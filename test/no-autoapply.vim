let g:cachedir_config = {'test': 'g:testing'}
let g:cachedir_auto_apply = 0

source plugin/cachedir.vim

AssertEqual 'pre-value', g:testing, "Should't have applied yet"

doautocmd BufWinEnter

AssertEqual 'pre-value', g:testing, "Should't have applied yet"

call Cachedir_apply_userconfig()

AssertEqual '/tmp/specific/test', g:testing, "Should have been applied"

