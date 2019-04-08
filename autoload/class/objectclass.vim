" 基础类定义
" Last Change:	2019.04.07
" Maintainer:   kevin.wang kevin.wang2004@hotmail.com	
" License:	This file is placed in the public domain.

scriptencoding utf-8

" 以下是面向对象的编程
let s:objectclass = {}
let s:objectclass.name = 'objectclass'
function! s:objectclass.status() abort dict
	echo self.name
endfunction

" 基本name属性
function! s:objectclass.setname(name) abort dict
	let self.name = a:name
endfunction
function! s:objectclass.getname() abort dict
	return self.name
endfunction

function! class#objectclass#new()
	let l:obj = deepcopy(s:objectclass)
	return l:obj
endfunction
