" 模块类定义
" Last Change:	2019.04.07
" Maintainer:   kevin.wang kevin.wang2004@hotmail.com	
" License:	This file is placed in the public domain.

scriptencoding utf-8

" 该module类继承自objectclass
let s:objectclass = deepcopy(class#objectclass#new()) 
call s:objectclass.setname('moduleclass')

function! class#moduleclass#new()
	let l:obj = deepcopy(s:objectclass)
	return l:obj
endfunction
