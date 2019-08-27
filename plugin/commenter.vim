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
	let s:cmnt_inses = s:GetComment(@a)
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
	let s:cmts = s:GetComment(a:lang)
	let s:start = s:cmts[0]
	let s:end = s:cmts[1]
	if s:start != ''
		echom 'Start: "' . s:start . '"'
	endif
	if s:end != ''
		echom 'End: "' . s:end . '"'
	endif
endfun

" ------------------------------------------------------------------------------
" Internal functions

" Get comment type
fun! s:GetComment(lang)
	let ret_start = '\?'
	let ret_end = ''
	let cmnts = [
	\	['//',	'',		['c', 'java', 'javascript', 'cpp', 'javascript.jsx']],
	\	['#',	'',		['python', 'sh', 'perl', 'ruby', 'r', 'asm', 'gitconfig', 'make', 'yaml']],
	\	['--',	'',		['haskell', 'sql']],
	\	['%',	'',		['matlab', 'plaintex']],
	\	['"',	'',		['vim']],
	\	['(*',	'*)',	['pascal']],
	\	["<!--",'-->',	['xml', 'html', 'php', 'markdown']],
	\	['/*',	'*/',	['css']],
	\]
	for cmnt in cmnts
		for l_val in cmnt[2]
			if a:lang == l_val
				let ret_start = cmnt[0]
				let ret_end = cmnt[1]
			endif
		endfor
	endfor
	return [ret_start, ret_end]
endfun

" ------------------------------------------------------------------------------
" Cleanup

let &cpo= s:keepcpo
unlet s:keepcpo
