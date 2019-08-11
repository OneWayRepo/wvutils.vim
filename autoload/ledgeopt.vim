" 将一些通用的函数，进行整合 
" 注意放在autoload目录下的文件，可以被自动加载
" 注意，在autoload目录下的文件并不是一开始就被加载的，只有等到
" 需要的时候才能被加载,可以叫作延迟加载
" Last Change:	2019.08.03
" Maintainer:   kevin.wang kevin.wang2004@hotmail.com	
" License:	This file is placed in the public domain.
" Description:	处理ledge账户输入的功能
scriptencoding utf-8

" 避免一个插件被加载多次
if exists('g:ledgeopt_exits') 
	finish
endif
let g:ledgeopt_exits = 1

" 账户信息的路径
if !exists('g:ledger_accounts_source_path') 
	let g:ledger_accounts_source_path='/home/kevin/account'
endif

" 整个账户信息需要的变量
let s:load_account_finish_flag = 0
" 全部原始数据
let s:accounts=[]

" 已经被选择了的账户集合
let s:preaccounts = []
function! ledgeopt#clean_pre_accounts() abort
	let s:preaccounts = []
endfun

" 获得下一代的账户信息 
function! ledgeopt#get_next_accounts() abort
	let aaaa =ledgeopt#get_list_accounts(s:preaccounts)
	echomsg aaaa
	return ledgeopt#get_list_accounts(s:preaccounts)
endfun

" 设置下一代的账户信息
function! ledgeopt#add_next_accounts(account) abort
	call add(s:preaccounts,a:account)
endfun

" 是否没有下一级的科目 
function! ledgeopt#whether_end_account() abort
	let s:result = ledgeopt#get_list_accounts(s:preaccounts)
	if len(s:result) == 0 
		return 1
	else
		return 0
	endif
endfun


" 载入全部的账户信息
function! ledgeopt#init_accounts(path) abort
	if s:load_account_finish_flag == 0
		let s:acline = readfile(a:path)
		for ac in s:acline
			if stridx(ac,'account') != -1
				let s:tt = strpart(ac,8) 
				let s:ellist = split(s:tt,':')
				call add(s:accounts,s:ellist)
			endif
		endfor

		let s:load_account_finish_flag = 1
	endif
endfunction

" 输入是一个包含　一级＼二级＼．．．账户信息的列表
" 依据一个ｌｉｓｔ获得下一级的ａｃｃｏｕｎｔｓ
function! ledgeopt#get_list_accounts(keylist) abort
	let s:length = len(a:keylist)
	let s:index = 0
	let s:flag = 0
	let s:object = []
	let s:tl = 0
	let s:maxdeep = 0
	for s:element in s:accounts
		let s:index = 0
		let s:flag = 0
		let s:maxdeep = len(s:element)
		if s:maxdeep < s:length
			let s:flag = 1
		else
			while s:index < s:length
				if s:element[s:index] != a:keylist[s:index] 
					let s:flag = 1
				endif
				let s:index = s:index + 1
			endwhile
		endif
		if s:flag == 0 
			let s:tl = s:length - 1
			if s:length < s:maxdeep 
				if len(s:element[s:length]) > s:tl
					call add(s:object,s:element[s:tl + 1])
				endif
			endif
		endif
	endfor
	call uniq(sort(s:object))
	return s:object
endfunction

" 计算账户科目的深度 
function! ledgeopt#calculate_accounts_deeps(accounts) abort
	let s:deep = 0
	for s:echolist in a:accounts
		let s:tlen = len(s:echolist)
		if s:deep < s:tlen 
			let s:deep = s:tlen
		endif
	endfor
endfunction

" 载入一级科目
function! ledgeopt#load_gaccounts() abort
	let s:gaccount=[]
	for s:element in s:accounts
		call add(s:gaccount,s:element[0])	
	endfor
	call uniq(sort(s:gaccount))
endfunction

" 载入二级科目
function! ledgeopt#load_saccounts(gaccount) abort
	let s:saccount=[]
	for s:element in s:accounts
		if s:element[0] == a:gaccount 
			if len(s:element) > 1
				call add(s:saccount,s:element[1])
			endif
		endif
	endfor
	call uniq(sort(s:saccount))
endfunction

" 载入三级科目
function! ledgeopt#load_taccounts(gaccount,saccount) abort
	let s:taccount=[]
	for s:element in s:accounts
		if s:element[0] == a:gaccount && s:element[1] == a:saccount
			if len(s:element) > 2
				call add(s:taccount,s:element[2])
			endif
		endif
	endfor
	call uniq(sort(s:taccount))
endfunction
