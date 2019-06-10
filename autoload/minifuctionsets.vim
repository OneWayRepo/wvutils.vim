" 将一些通用的函数，进行整合 
" 注意放在autoload目录下的文件，可以被自动加载
" 注意，在autoload目录下的文件并不是一开始就被加载的，只有等到
" 需要的时候才能被加载,可以叫作延迟加载
" Last Change:	2019.03.09
" Maintainer:   kevin.wang kevin.wang2004@hotmail.com	
" License:	This file is placed in the public domain.

scriptencoding utf-8

" 避免一个插件被加载多次
if exists('g:minifuctionsets_exits') 
	finish
endif
let g:minifuctionsets_exits = 1

function! minifuctionsets#version()
	return '1.0.0'
endfunction

" 进行字符串的显示，如果flag == 1,显示高亮
"                   如果flag == 0,普通显示
" !表示这个函数可以被安全的重载
function! minifuctionsets#message(arg,flag) abort
	if a:flag == 1
		echohl Title " 高亮以下内容 注意以下一定要a:打头，否者调用不到arg这个内部变量
	endif  	
	"使用echomsg命令的目的是将日志显示在message区域当中,使用message可以查看
	echomsg a:arg
	if a:flag == 1
		echohl None  " 结束高亮显示
	endif
	return
endfunction

" 在当前打开的文件下，写入一个字符串
" 的作用是使得函数生成一个唯一的ID数值
function! minifuctionsets#appendtexttofile(pos,astring) abort
	let failed = append(a:pos, a:astring)
	return
endfunction

" 异步创建创建目录，使用job_start/job_status 的函数来创建目录
function! minifuctionsets#asyn_create_dir(path,dir) abort
	let s:dest = a:path . "/" . a:dir
	echomsg s:dest 
	let job = job_start(["/bin/sh","-c","mkdir -p " . s:dest])

	if job_status(job) != "dead"
		echomsg s:dest + "目录创建失败"
	endif

	" {'status': 'dead', 'cmd': ['/bin/sh', '-c', 'mkdir -p ~/123'],
	" 'termsig': '', 'stoponexit': 'term', 'tty_out': '', 'exitval': 0,
	" 'exit_cb': '', 'tty_in': '', 'channel': 'channel 0 open', 'proc
	" ess': 91367}
	"echo job_info(job) 
endfunction
