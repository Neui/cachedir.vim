`cachedir.vim`
==============

Unify your caching directory and set your preferences globally. It just
sets variables to the directory.

It currently supports out of the box:

* vim swap file
* vim persistent undo
* [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
* [vim-CtrlSpace](https://github.com/vim-ctrlspace/vim-ctrlspace)
* [ale](https://github.com/w0rp/ale)

Support for more plugins(/variables) can be easily added by the user itself
or even by the plugins itself.

Installing
----------

Use the plugin system you're using.

| Plugin Manager      |  Installing line             |
|---------------------|------------------------------|
| [vim-plug][pm1]     | `plug 'Neui/cachedir.vim'`   |
| [vundle][pm2]       | `plugin 'Neui/cachedir.vim'` |

[pm1]: https://github.com/junegunn/vim-plug
[pm2]: https://github.com/vundlevim/vundle.vim

Usage
-----

For more information, please read the documentation located in
[doc/cachedir.txt](doc/cachedir.txt), or `:help cachedir.txt`. The following
is basically a big quote out of it.

You don't interact this plugin on a daily basis, rather you only set it up
initially and for new plugins, if a particular plugin doesn't support cachedir
or cachedir doesn't support that plugin yet. In other words, it's supposed to
be set-and-forget with minimal configuration.

The main variables are `g:cachedir_config`, `g:cachedir_prefix`,
`g:cachedir_vimprefix` and `g:cachedir_globalprefix`.

A path is constructed like this: (ASCII art)

	          /home/neui/.cache / vim- gutentags
	          ---+------------- | --+- -------------> NAME
	             V              |   V
	  g:cachedir_prefix         V  g:cachedir_vimprefix
	                   g:cachedir_dirsep

Or when the 'global' in `g:cachedir_config` has been set to `1`:

	          /home/neui/.cache / vim/
	          ---+------------- | --+-
	             V              |   V
	  g:cachedir_prefix         V  g:cachedir_globalprefix
	                   g:cachedir_dirsep

If you like the default settings, and the plugin is supported, there is
nothing to do. However, if you want to add support for a plugin, define
`g:cachedir_config` as your liking, see `g:cachedir_config` for more
information. Here's a example:

	let g:cachedir_config = {
				\ 'NAME': 'g:VAR TO BE SET',
				\ 'OTHERNAME': {
				\	'var': 'g:OTHERNAME_CACHEDIR',
				\	'prepend': 1
				\ }
				\ }


The variable `g:cachedir_prefix` is a path to the general cache directory.
By default, it's `$TEMP`, or `$TMP` (both only on Windows), `$XDG_CACHE_HOME`
or `~/.cache` otherwise.

The variable `g:cachedir_vimprefix` is the path inside the prefix above.
If this variable doesn't end with a `/`, for example `vim-`, the directories
are then called `prefix/vim-NAME`. The default is `vim-`.

The variable `g:cachedir_globalprefix` is basically the global version of
`g:cachedir_vimprefix`, meant for plugins that their cache is shared (and
there is no naming conflict). By default, it's `vim/`.

Another main part of the configuration is `g:cachedir_config`.
This is a dictionary, basically describing what variables there are, how to
handle them and so on.

Each key is a name (usually the plugin name), normally used as a name for the
directory.

Each value is either a string, containing the variable name to be set, or `'x'`
to ignore it (see `'ignore'` below), or an another dictionary, detailing
more options. These are:

* `'var'` (String): The variable name to set.
* `'ignore'` (0/1): Ignore, don't apply whatsoever.
* `'prepend'` (0/1): Whenever it should prepend it, along with a comma
* `'prepend-sep'` (String): Prepend separator
* `'append'` (0/1): Whenever it should append it, along with a comma
* `'append-sep'` (String): append separator
* `'cond'` (String): Code that gets executed to check if it should apply it
* `'name'` (String): Name of the directory, normally the key
* `'pre'` (String): Prefix for the complete path
* `'suf'` (String): Suffix for the complete path
* `'global'` (0/1): Whenever it should use a global directory
* `'path'` (String): Explicit path, normally determined automatically
* `'prefix'` (String): Custom `g:cachedir_prefix`
* `'vimprefix'` (String): Custom `g:cachedir_vimprefix` or
  `g:cachedir_globalprefix`, depending on the global attribute

Here's an copy-pasteable version for convince with default values:

		\ 'NAME': {
		\ 	'var': 'unknown',
		\ 	'ignore': 0,
		\ 	'cond': '1 == 1',
		\ 	'prepend': 0,
		\ 	'prepend-sep': ',',
		\ 	'append': 0,
		\ 	'append-sep': ',',
		\ 	'global': 0,
		\ 	'prefix': '',
		\ 	'vimprefix': '',
		\ 	'globalprefix': '',
		\ 	'path': '',
		\ 	'name': '',
		\ 	'pre': '',
		\ 	'suf': '',
		\ }

Since your user config has the highest priority, please take out the unused
fields!
