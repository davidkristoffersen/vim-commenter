" Author:		David Kristoffersen <david.alta2010@gmail.com>
" Description:	Comment lines in a series of languages
" Version:		1.0

" ------------------------------------------------------------------------------
" Initialization

" Exit when your app has already been loaded
if exists("g:loaded_commenter") || &cp
	finish
endif

let g:loaded_commenter = 1.0 " your version number
let s:keepcpo          = &cpo
set cpo&vim

" ------------------------------------------------------------------------------
" Public Interface

" CommenterToggle: Echo comment type to language
" CommenterGetComment: Toggle line comment
" DefaultLeader: The default leader is `ct`
" DisableDefaultLeader: Comment out the if test below

" if !hasmapto('<Plug>CommenterToggle')
	" map <unique> <Leader>ct <Plug>CommenterToggle
" endif

" ------------------------------------------------------------------------------
" Global Maps:

noremap <silent> <unique> <script> <Plug>CommenterToggle
	\ :set lz<CR>:call CommenterToggle()<CR>:set nolz<CR>

" ------------------------------------------------------------------------------
" Global variables

let g:CommenterComments = [
	\	['//',	'',		['c', 'java', 'javascript', 'cpp', 'rust', 'cuda', 'cs']],
	\	['#',	'',		['python', 'sh', 'perl', 'ruby', 'r', 'asm', 'gitconfig', 'make', 'yaml', 'i3config', 'dosini', 'conf', 'xdefaults', 'readline', 'cfg']],
	\	['--',	'',		['haskell', 'sql']],
	\	['%',	'',		['matlab', 'plaintex']],
	\	['"',	'',		['vim']],
	\	['(*',	'*)',	['pascal']],
	\	["<!--",'-->',	['xml', 'html', 'php', 'markdown']],
	\	['/*',	'*/',	['css']],
	\]

" ------------------------------------------------------------------------------
" Global functions

" Toggle line comment
fun! g:CommenterToggle()
	" Map to secondary function
	nnoremap <silent> <Left> :set lz<CR>:silent! call CommenterGetComment()<CR>:set nolz<CR>

	" Detect file type
	redir @a
	silent echon &ft
	redir END

	" Set comment type
	let s:cmnt_inses = s:CommenterGetCommentList(@a)
	let s:cmnt_ins = s:cmnt_inses[0]
	let s:cmnt_ins_end = s:cmnt_inses[1]
	let s:cmnt_del = len(s:cmnt_ins)
	let s:cmnt_del_end = len(s:cmnt_ins_end)

	" Test if comment is spaced right
	execute "normal! mxI\<Right>\<Esc>"
	let s:tmp = expand('<cWORD>')
	execute "normal! " . s:cmnt_del . "\<Right>i \<Esc>I\<Right>\<Esc>"
	let s:cmnt_status = expand('<cWORD>')

	if s:cmnt_status != s:cmnt_ins
		" Comment out line
		execute "normal! " . s:cmnt_del . "\<Right>x`x"
		execute "normal! mxI" . s:cmnt_ins . " \<Esc>`x"
		if s:cmnt_ins_end != ""
			execute "normal! mxA " . s:cmnt_ins_end . "\<Esc>`x"
		endif	
	else
		" Un-comment out line
		if s:tmp == s:cmnt_status
			execute "normal! " . s:cmnt_del . "\<Right>x`x"
		else
			execute "normal! `x"
		endif
		execute "normal! mxI\<Right>\<Esc>" . s:cmnt_del . "xx\<Esc>`x"
		if s:cmnt_ins_end != ""
			execute "normal! mxA\<Esc>" . s:cmnt_del_end . "\<Left>\<Esc>" . s:cmnt_del_end ."xx\<Esc>`x"
		endif	
	endif
endfun

" Echo comment type to language
fun! g:CommenterGetComment(lang)
	let s:cmts = s:CommenterGetCommentList(a:lang)
	let s:start = s:cmts[0]
	let s:end = s:cmts[1]
	if s:start != ''
		echom 'Start: "' . s:start . '"'
	endif
	if s:end != ''
		echom 'End: "' . s:end . '"'
	endif
endfun

" Get comment type of current document
fun! g:CommenterGetCommentList(...)
	if a:0 == 1
		return s:CommenterGetCommentList(a:1)
	endif

	let l:ft = &ft
	return s:CommenterGetCommentList(l:ft)
endfun

fun! g:CommenterGetLanguages()
	let l:ret = []
	for l:lang_type in g:CommenterComments
		for l:lang in l:lang_type[2]
			call add(l:ret, l:lang)
		endfor
	endfor
	return l:ret
endfun

" ------------------------------------------------------------------------------
" Internal functions

" Get comment type
fun! s:CommenterGetCommentList(lang)
	let l:ret_start = '\?'
	let l:ret_end = ''
	for cmnt in g:CommenterComments
		for l_val in cmnt[2]
			if a:lang == l_val
				let l:ret_start = cmnt[0]
				let l:ret_end = cmnt[1]
			endif
		endfor
	endfor
	return [l:ret_start, l:ret_end]
endfun

" ------------------------------------------------------------------------------
" Cleanup

let &cpo= s:keepcpo
unlet s:keepcpo
