" 通用库脚本库 
" Last Change:	2019.03.05 
" Maintainer:   kevin.wang kevin.wang2004@hotmail.com	
" License:	This file is placed in the public domain.

scriptencoding utf-8

" 避免一个插件被加载多次
if exists('g:wvutils_exits') 
	finish
endif
let g:wvutils_exits = 1

" 避免扩展命令运行
if (v:progname == "ex")
   finish
endif

function! <SID>AddComment() abort
	call minifuctionsets#appendtexttofile(line('.') - 1,'//')
	call minifuctionsets#appendtexttofile(line('.') - 1,'//')
	call minifuctionsets#appendtexttofile(line('.') - 1,'//')
endfunction

let s:wvu_draftfile = expand('~/.vim/__DRAFT__')

augroup DraftGroup
	autocmd!
	autocmd bufenter __DRAFT__ if (winnr("$") == 1) | q | endif
	autocmd VimEnter *
			\   if !argc()
			\ |   execute 'WvuPreview'
			\ |   wincmd h
			\ | endif
augroup END

" 创建一个窗体，指定宽度的窗体
function! <SID>Core_Edit(width) abort
	let b:draft_flag = 'Draft'
	silent! execute 'vertical botright ' . a:width . 'split ' . g:wvu_draftpath
endfunction

" 打开一个草稿文件
function! <SID>SplitDraft() abort
	if !exists('g:wvu_draftpath')
		let g:wvu_draftpath = s:wvu_draftfile
	endif
	let s:fileexist = 0
	if filereadable(g:wvu_draftpath) 
		let s:fileexist = 1
	endif

	if s:fileexist == 1
		"是否重新创建新草稿纸
		let s:load_oldpaper=confirm("是否载入旧草稿纸?","&Yes\n&No",2)
		if s:load_oldpaper == 2
			let s:delete_oldpaper=confirm("要删除旧草稿纸内容了?","&Yes\n&No",2)
			if 	s:delete_oldpaper == 2
				return
			elseif s:delete_oldpaper == 1
				let s:fileexist = 0
				call delete(g:wvu_draftpath)
			endif
		endif
	endif
	call <SID>Core_Edit(50)
	if s:fileexist == 0
		let failed = minifuctionsets#appendtexttofile(0,"<<----草稿纸---->>")
	endif
	return
endfunction

" preview与Draft的区别是这个只是浏览
function! <SID>SplitPreview() abort
	if !exists('g:wvu_draftpath')
		let g:wvu_draftpath = s:wvu_draftfile
	endif
	if filereadable(g:wvu_draftpath) 
		" 仅仅为了说明闭包函数的作用
		function! Calwinwidth(width) closure
			return a:width * 2 
		endfunction
		call <SID>Core_Edit(Calwinwidth(25))
		" 注意，运行到此处的时候，焦点已经在新的窗体中了。
		set readonly
		set winfixwidth
	endif
	return
endfunction

"call minifuctionsets#version("-- 欢迎进入vim世界 --",1)

let s:wvutils_version = 'v1.0.1'
if !exists('s:wvutils_version')
	let s:wvutils_version = 'v1.0.0(init)'
endif
"call minifuctionsets#version("wvutils plugins version: ".s:wvutils_version,0)

"　输入字符串
"let s:inputmsg = input('输入想要保存的内容: ')
"try
"	call writefile([s:inputmsg],s:tmpfile,'a')
"	call minifuctionsets#version('写入临时文件：'.s:tmpfile.' 成功',0)
"catch
"	echo '写入文件 ' . s:tmpfile . ' 失败!'
"endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 对外提供的接口函数
" 注意此处的定义方式
"call wvutils#welcome()
function! g:wvutils#welcome() abort
	call minifuctionsets#message("当前wvutils模块的版本:".s:wvutils_version,1)
endfunction
function! g:wvutils#version() abort
	return	s:wvutils_version
endfunction

" Replace 替换函数 
function! <SID>Replace() abort
	let s:src    = input("输入被替换字符串: ", "")
	let s:des    = input("输入替换字符串: ", "")
	if s:src != '' && s:des != ''
		execute "%s/".s:src."/".s:des."/"."gc"
	endif
endfunction

" Test 函数用于自己测试使用
function! <SID>Test() abort
	call ledgeopt#load_gaccounts("/home/kevin/account")
	return
	" 每一个dictionary 包含一个key-value对
	" 之间用colon(冒号)分离
	" 注意 key 都是字符串,就算是数字，也是字符串
	"let mydict = { 1:'hello', 2:'second', 'kevin':'wangwei' }
	"call minifuctionsets#message(mydict[1],1)
	"call minifuctionsets#message(mydict[2],1)
	"call minifuctionsets#message(mydict['kevin'],1)
	"for key in keys(mydict)
	"	call minifuctionsets#message(key . ' : ' . mydict[key],1)
	"endfor
	"for v in values(mydict)
	"	call minifuctionsets#message(v,1)
	"endfor
	"let accountdict = { '收入':{ '工资':['公司薪资','分红'],'福利':['福利卡','购物卡','补贴'],'理财':['股票','建行理财','余额宝'] }, '支出':{ '饮食':['早餐','晚餐','中餐'],'交通':['私家车','汽油','年检'],'人情':['红包'] }, '资产':{ '父母财产':['红包','赠与'],'期初导入':['上年结余','夫妻财产'] } }

	"for k1 in keys(accountdict)
	"	for  k2 in keys(accountdict[k1])
	"		call minifuctionsets#message(accountdict[k1][k2],1)
	"	endfor
	"endfor
	"let color = inputlist(['Select color:', '1. red',
	"	\ '2. green', '3. blue'])
	" call minifuctionsets#message("当前颜色:",1)
	"call pythonfunctionset#pythonprint("hello")

	"call minifuctionsets#asyn_create_dir("/home/kevin","123")
	
	let s:account=[]
	let s:acline = readfile("/home/kevin/account")
	for ac in s:acline
		let s:ellist = split(ac,':')
		call add(s:account,s:ellist)
	endfor

	let s:account1=[]
	for s:element in s:account
		call add(s:account1,s:element[0])	
	endfor
	call uniq(sort(s:account1))	
	echo s:account1

	let s:account2=[]
	for s:element in s:account
		if s:element[0] == '支出'
			call add(s:account2,s:element[1])	
		endif
	endfor
	call uniq(sort(s:account2))	
	echo s:account2

	let s:account3=[]
	for s:element in s:account
		if s:element[0] == '支出' && s:element[1] == '用车'
			call add(s:account3,s:element[2])	
		endif
	endfor
	call uniq(sort(s:account3))
	echo s:account3
endfunction

fun! CompleteMonths(findstart, base) abort
	if a:findstart
		" locate the start of the word
		let line = getline('.')
		let start = col('.') - 1
		while start > 0 && line[start - 1] =~ '\a'
			let start -= 1
		endwhile
		return start
	else
		" find months matching with "a:base"
		for m in split("Jan1 Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec")
			if m =~ '^' . a:base
				call complete_add(m)
			endif
			sleep 300m	" simulate searching for next match
			if complete_check()
				break
			endif
		endfor
		return []
	endif
endfun

"　补全账户信息
fun! CompleteAccount(findstart, base) abort
	if a:findstart
		" locate the start of the word
		let line = getline('.')
		let start = col('.') - 1
		while start > 0 && line[start - 1] =~ '\a'
			let start -= 1
		endwhile
		return start
	else
		let s:account=[]
		let s:acline = readfile("/home/kevin/account")

		for m in s:acline
			call complete_add(m)
			sleep 100m	" simulate searching for next match
			if complete_check()
				break
			endif
		endfor
		return []
	endif
endfun
" Ctrl-X  Ctrl-U之后进行触发
set completefunc=CompleteAccount

func TimerProcess(timer)
	echo 'Handler called'
endfunc
function! <SID>StartTimer(meclips)
	let s:eclips = a:meclips * 1000
	let timer = timer_start(s:eclips, 'TimerProcess', {'repeat': 3})
endfunction

" 以下是面向对象的编程
let s:ClassObject = {}
let s:ClassObject.name = ''
let s:ClassObject.id   = 0
function! s:ClassObject.status() abort dict
	echo self.name
endfunction

" 多态与继承
let s:ClassSub1 = deepcopy(s:ClassObject)
function! s:ClassSub1.status() abort dict
	echo 'Sub1:' . self.name
endfunction
let s:ClassSub2 = deepcopy(s:ClassObject)
function! s:ClassSub2.status() abort dict
	echo 'Sub2:' . self.name
endfunction

function! <SID>test_oo_function() abort
	let l:object 	  = deepcopy(s:ClassObject) 
	let l:object.name = 'Object'
	call l:object.status()

	let l:sub1 	  = deepcopy(s:ClassSub1) 
	let l:sub1.name   = 'sub1'
	call l:sub1.status()

	let l:sub2 	  = deepcopy(s:ClassSub2) 
	let l:sub2.name   = 'sub2'
	call l:sub2.status()

	let l:obj 	  = class#objectclass#new()
	call l:obj.status()

	let l:mobj 	  = class#moduleclass#new()
	call l:mobj.status()
	call l:mobj.setname('hero')
	call l:mobj.status()

endfunction

" 这样可以进行命令行与normal命令的链接
function! <SID>NormalInstrument() abort
	execute 'normal gg'
endfunction

" 自定义命令,注意命令的首字母必须要大写
" :WvuFight <cr> 这样就能调用
command! -nargs=0 WvuFight    		call minifuctionsets#message("祝你好运",1)
command! -nargs=0 WvuText     		call minifuctionsets#appendtexttofile(0,"hello")
command! -nargs=0 WvuDraft    		call <SID>SplitDraft()
command! -nargs=0 WvuPreview   		call <SID>SplitPreview()
command! -nargs=0 WvuComment  		call <SID>AddComment()
command! -nargs=0 WvuTest     		call <SID>Test()
command! -nargs=0 Wvuootest  		call <SID>test_oo_function()
command! -nargs=0 WvuReplace  		call <SID>Replace()
" 添加需要函数参数的命令
" 需要添加秒数为参数
command! -nargs=1 WvuStartTimer     	call <SID>StartTimer(<args>)
command! -nargs=0 WvuInstrument  	call <SID>NormalInstrument()
