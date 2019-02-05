let g:cachedir_config = {'test': {'var': 'g:testing', 'name': 'hey'}}

source plugin/cachedir.vim
doautocmd BufWinEnter

AssertEquals '/tmp/specific/hey', g:testing
