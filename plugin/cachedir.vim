" This plugin lets the user specify a 'global cache directory'
" Version:	1.0
" Author:	Neui
" License:	BSD 2-Clause

if exists("g:cachedir_loaded")
	finish
endif
let g:cachedir_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

let g:cachedir_version = '1.0'

let g:cachedir_config = get(g:, "cachedir_config", {})
let g:cachedir_dirsep = get(g:, "cachedir_dirsep", '/')
let g:cachedir_vimprefix = get(g:, "cachedir_vimprefix", 'vim-')
let g:cachedir_globalprefix = get(g:, "cachedir_globalprefix", 'vim/')
let g:cachedir_auto_apply = get(g:, "cachedir_auto_apply", 1)
let g:cachedir_init_applied = get(g:, "cachedir_init_applied", 0)
let g:cachedir_plugin_config = get(g:, "cachedir_plugin_config", {})

function! s:get_default_prefix()
	if has("win32") || has("win64")
		" https://docs.microsoft.com/de-de/windows/desktop/api/fileapi/nf-fileapi-gettemppatha
		if exists("$TEMP")
			return $TEMP
		endif
		if exists("$TMP")
			return $TMP
		endif
		" Fall through because I think a seperate cache dir is better
		" than dumping into the user profile or windows directory
	endif
	" Try to use XDG_CACHE_HOME
	if exists("$XDG_CACHE_HOME") && !empty($XDG_CACHE_HOME)
		return $XDG_CACHE_HOME
	endif
	" Default to the default $XDG_CACHE_HOME
	return expand('~/.cache')
endfunction
if !exists("g:cachedir_prefix")
	let g:cachedir_prefix = s:get_default_prefix()
endif

let s:cachedir_default = {
			\ 'var': 'unknown',
			\ 'ignore': 0,
			\ 'cond': '1 == 1',
			\ 'prepend': 0,
			\ 'prepend-sep': ',',
			\ 'append': 0,
			\ 'append-sep': ',',
			\ 'global': 0,
			\ 'prefix': '',
			\ 'vimprefix': '',
			\ 'globalprefix': '',
			\ 'path': '',
			\ 'name': '',
			\ 'pre': '',
			\ 'suf': '',
			\ 'mkdir': 0,
			\ }

let s:cachedir_defaults = {
			\ 'undo': {
			\	'var': 'undodir',
			\	'cond': 'has("persistent_undo")',
			\	'mkdir': 1,
			\ },
			\ 'swap': {
			\	'var': '&directory',
			\	'suf': '//',
			\	'prepend': 1,
			\	'mkdir': 1,
			\ },
			\ 'gutentags': 'g:gutentags_cache_dir',
			\ 'ctrlspace': {'var': 'g:CtrlSpaceCacheDir', 'global': 1},
			\ 'ale_cpp': {'var': 'g:ale_cpp_cquery_cache_directory',
			\	'name': 'cquery'},
			\ 'ale_c': {'var': 'g:ale_c_cquery_cache_directory',
			\	'name': 'cquery'},
			\ }

function! s:val_to_dict(val)
	if type(a:val) == type('') && a:val == 'x'
		return {'ignore': 1}
	elseif type(a:val) == type('')
		return {'var': a:val}
	elseif type(a:val) == type({})
		return a:val
	endif
	echoerr "cachedir: Internal error! val isn't either a dict or string"
endfunction

" Let plugins construct their own path for whatever reason
function! Cachedir_construct_path(name, ...)
	let l:val = a:0 > 0 ? a:1 : s:cachedir_default
	let l:prefix = !empty(l:val['prefix']) ?
				\ l:val['prefix'] : g:cachedir_prefix
	let l:vimprefix = !empty(l:val['vimprefix']) ?
				\ l:val['vimprefix'] : g:cachedir_vimprefix
	let l:globalprefix = !empty(l:val['globalprefix']) ?
				\ l:val['globalprefix'] : g:cachedir_globalprefix
	let l:globalprefix = g:cachedir_globalprefix
	let l:name = !empty(l:val['name']) ? a:1['name'] : ''
	let l:pre = !empty(l:val['pre']) ? a:1['pre'] : ''
	let l:suf = !empty(l:val['suf']) ? a:1['suf'] : ''
	if l:val['global'] != 0
		let l:vimprefix = l:globalprefix
		let l:name = ''
	endif
	return l:pre . l:prefix . g:cachedir_dirsep . l:vimprefix . l:name . l:suf
endfunction

" Get effective setting for something
function! Cachedir_get(name, ...)
	let l:val = deepcopy(s:cachedir_default)
	let l:val['name'] = a:name
	let l:val['prefix'] = g:cachedir_prefix
	let l:val['vimprefix'] = g:cachedir_vimprefix
	
	if has_key(s:cachedir_defaults, a:name)
		call extend(l:val, s:val_to_dict(s:cachedir_defaults[a:name]))
	endif
	
	if has_key(g:cachedir_plugin_config, a:name)
		call extend(l:val, s:val_to_dict(g:cachedir_plugin_config[a:name]))
	endif
	
	if a:0 >= 1
		call extend(l:val, s:val_to_dict(a:1))
	endif
	
	if has_key(g:cachedir_config, a:name)
		call extend(l:val, s:val_to_dict(g:cachedir_config[a:name]))
	endif
	
	if empty(l:val['name'])
		let l:val['name'] = a:name
	endif
	
	if empty(l:val['path'])
		let l:val['path'] = Cachedir_construct_path(a:name,
					\ l:val)
	endif
	
	return l:val
endfunction

function! s:apply(cfg)
	if a:cfg['ignore'] != 0
		return
	endif
	if !eval(a:cfg['cond'])
		return
	endif
	
	let l:path = a:cfg['path']
	
	if a:cfg['mkdir'] != 0
		mkdir(l:path, 'p')
	endif
	
	if a:cfg['prepend'] != 0
		let l:sep = a:cfg['prepend-sep']
		execute(printf("let %s = l:path . l:sep . %s", a:cfg['var'],
					\ a:cfg['var']))
	endif
	if a:cfg['append'] != 0
		let l:sep = a:cfg['append-sep']
		execute(printf("let %s = %s . l:sep . l:path", a:cfg['var'],
					\ a:cfg['var']))
	endif
	if a:cfg['prepend'] == 0 && a:cfg['append'] == 0
		execute(printf("let %s = l:path", a:cfg['var']))
	endif
endfunction

" Apply for a certain configuration
function! Cachedir_apply_for(name, ...)
	call s:apply(Cachedir_get(a:name, a:0 > 0 ? a:1 : {}))
endfunction

" Apply from configuration
function! Cachedir_apply_userconfig()
	let l:keys = copy(keys(s:cachedir_defaults))
	call extend(l:keys, copy(keys(g:cachedir_config)))
	call extend(l:keys, copy(keys(g:cachedir_plugin_config)))
	call uniq(sort(l:keys))
	for key in l:keys
		call Cachedir_apply_for(key)
	endfor
	doautocmd User CachedirApplyAll
	let g:cachedir_init_applied = 1
endfunction

" See |User|: |:doautocmd| NEEDS at least one command to execute, otherwise
" it makes an error; Just use dummy commands here
autocmd User CachedirApplyAll :echo
autocmd User CachedirInitApplyAll :echo
autocmd User CachedirInit :echo

doautocmd User CachedirInit

function! s:apply_uc_once()
	if g:cachedir_init_applied == 0
		call Cachedir_apply_userconfig()
		doautocmd User CachedirInitApplyAll
	endif
endfunction

if g:cachedir_auto_apply != 0
	autocmd BufWinEnter * call s:apply_uc_once()
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:tw=79:ts=8:sw=8
