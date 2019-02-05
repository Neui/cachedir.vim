" Autoload plugin register (pre loading)

try
	call cachedir#register('test', 'g:testing')
catch /Vim(call):E117:.*/
	" No cachedir plugin found, do nothing
	AssertSuccess
endtry
AssertFail "Didn't throw an unknown function exception"
