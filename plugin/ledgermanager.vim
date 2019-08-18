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
		" 注意一定要双引号
		let s:msg = input("输入凭证 ", s:date."\<Tab>".'*'." ")
		let failed = append(line('.') - 1,s:msg)
		return ''
	else
		return '/'
	endif
endfunction

" 查找:数目函数
function! <SID>calculate_colon() abort
	let s:linestr = getline(".")
	let maxlength = len(s:linestr)
	let s:number_colon = 0
	if maxlength == 0
		return s:number_colon
	endif
	let index = 0
	while index != maxlength
		if s:linestr[index] == ':'
			let s:number_colon = s:number_colon + 1
		endif
		let index = index + 1
	endwhile
	return s:number_colon
endfunction

" 将文件中的内容以pop的方式显示出来
function! <SID>ListAccount() abort
	" &的定义描述见该文件头部
	if &filetype == 'ledger'
		let s:number_colon = <SID>calculate_colon()

		if s:number_colon == 0
			call ledgeopt#init_accounts(g:ledger_accounts_source_path)
			call ledgeopt#clean_pre_accounts()
		endif
		let s:account = ledgeopt#get_next_accounts()

		if s:account == [] 
			return ''
		endif

		call s:ListContain(s:account)
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
	call ledgeopt#add_next_accounts(v:completed_item['word'])

	if ledgeopt#whether_end_account()
		call setline(line('.'),getline(".") . "\<Tab>\<Tab>" . '￥')
		call cursor(line('.'),col('.') + 9)
	else
		call setline(line('.'),getline(".") . ':')
		call cursor(line('.'),col('.') + 1)
	endif
endfun

" 在popupmenu中显示内容
function! s:ListContain(contain) abort
	call complete(col('.'), a:contain)
	return ''
endfunc

