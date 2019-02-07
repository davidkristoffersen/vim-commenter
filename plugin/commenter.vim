"
" Vim commenting plugin
"

" Get comment type
function! Get_cmnt(lang)
	let ret_start = '\?'
	let ret_end = ''
	let cmnts = [
	\	['//',	'',		['c', 'java', 'javascript', 'cpp']],
	\	['#',	'',		['python', 'sh', 'perl', 'ruby', 'r', 'asm', 'gitconfig', 'make']],
	\	['--',	'',		['haskell', 'sql']],
	\	['%',	'',		['matlab', 'tex']],
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
endfunction

function! Comment_toggle()
	" Detect file type
	redir @a
	silent echon &ft
	redir END

	" Set comment type
	let g:cmnt_inses = Get_cmnt(@a)
	let g:cmnt_ins = g:cmnt_inses[0]
	let g:cmnt_ins_end = g:cmnt_inses[1]
	let g:cmnt_del = len(g:cmnt_ins)
	let g:cmnt_del_end = len(g:cmnt_ins_end)

	" Test if comment is spaced right
	execute "normal! mxI\<Right>\<Esc>"
	let g:tmp = expand('<cWORD>')
	execute "normal! " . g:cmnt_del . "\<Right>i \<Esc>I\<Right>\<Esc>"
	let g:cmnt_status = expand('<cWORD>')

	if g:cmnt_status != g:cmnt_ins
		" Comment out line
		execute "normal! " . g:cmnt_del . "\<Right>x`x"
		execute "normal! mxI" . g:cmnt_ins . " \<Esc>`x"
		if g:cmnt_ins_end != ""
			execute "normal! mxA " . g:cmnt_ins_end . "\<Esc>`x"
		endif	
	else
		" Un-comment out line
		if g:tmp == g:cmnt_status
			execute "normal! " . g:cmnt_del . "\<Right>x`x"
		else
			execute "normal! `x"
		endif
		execute "normal! mxI\<Right>\<Esc>" . g:cmnt_del . "xx\<Esc>`x"
		if g:cmnt_ins_end != ""
			execute "normal! mxA\<Esc>" . g:cmnt_del_end . "\<Left>\<Esc>" . g:cmnt_del_end ."xx\<Esc>`x"
		endif	
	endif
endfunction
