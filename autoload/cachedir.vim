
function! cachedir#register(name, cfg)
	" Register cachedir plugin
	if !exists("g:cachedir_plugin_config")
		let g:cachedir_plugin_config = {}
	endif
	let g:cachedir_plugin_config[a:name] = a:cfg
	" Re-Apply config if neccesary
	if exists("g:cachedir_init_applied") && g:cachedir_init_applied == 1
		call Cachedir_apply_for(a:name)
	endif
endfunction

function! cachedir#apply_usercofig()
	if exists('*Cachedir_apply_userconfig')
		call Cachedir_apply_userconfig()
	else
		let g:cachedir_auto_apply = 1
	endif
endfunction

" vim:tw=79:ts=8:sw=8
