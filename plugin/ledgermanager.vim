" 通用库脚本库 
" Last Change:	2019.03.05 
" Maintainer:   kevin.wang kevin.wang2004@hotmail.com	
" License:	This file is placed in the public domain.
" Description:	账户输入管理文件

scriptencoding utf-8

" 避免一个插件被加载多次
if exists('g:ledgermanager_exits') 
	finish
endif
let g:ledgermanager_exits = 1

" 避免扩展命令运行
if (v:progname == "ex")
   finish
endif

" 在插入的状态下，键入:，并且如果是ledger文件类型
" 就能调用这个函数
inoremap : <C-R>=<SID>ListAccount()<CR>
inoremap / <C-R>=<SID>EnterDate()<CR>

" 显示日期
function! <SID>EnterDate() abort
	if &filetype == 'ledger'
		let s:date = strftime("%Y/%m/%d")
		let s:msg = input("输入凭证 ", s:date."\<Tab>\<Tab>".'*')
		let failed = append(line('.') - 1,s:msg)
		return ''
	else
		return '/'
	endif
endfunction

" 查找:符号的函数
function! <SID>findflag() abort
	let s:linestr = getline(".")
	let maxlength = len(s:linestr)
	let s:flag = 0
	if maxlength == 0
		return s:flag
	endif
	let index = 1
	while index != maxlength
		let index = index + 1
		if s:linestr[index] == ':'
			let s:flag = s:flag + 1
		endif
	endwhile
	return s:flag
endfunction

" 将文件中的内容以pop的方式显示出来
function! <SID>ListAccount() abort
	" &的定义描述见该文件头部
	" s:mflag 只有3级
	if &filetype == 'ledger'
		let s:mflag = <SID>findflag()
		if s:mflag > 4
			let s:mflag = 4
		endif
		call ledgeopt#set_account_level(s:mflag+1)
		let s:account = ledgeopt#get_accounts()
		let s:newcontain = ['']
		let s:empty = ''
		if s:mflag < 2
			let s:empty = ':'
		elseif s:mflag == 2
			" 注意转意字符一定要用双引号
			let s:empty = "\<Tab>\<Tab>" . '￥'
		endif

		for n in s:account
			call add(s:newcontain,n.s:empty)
		endfor

		call s:ListContain(s:newcontain)

  		return ''
	endif
	" 正常的非ledger文件格式的文件
	return ':'
endfunc

" 账户补全之后的事件
augroup CompleteEventGroup
	autocmd!
	autocmd CompleteDone *.ldg call s:AccountFinish() 
augroup END
fun! s:AccountFinish() abort
	let s:level = ledgeopt#get_account_level() 
	if 	s:level == 1
		call ledgeopt#set_gaccount(ledgeopt#filte_string(v:completed_item['word']))
	elseif	s:level == 2
		call ledgeopt#set_saccount(ledgeopt#filte_string(v:completed_item['word']))
	endif
endfun

" 在popupmenu中显示内容
function! s:ListContain(contain) abort
	call complete(col('.'), a:contain)
	return ''
endfunc

