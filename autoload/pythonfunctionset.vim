" 使用python接口实现的通用库脚本库 
" Last Change:	2019.03.25 
" Maintainer:   kevin.wang kevin.wang2004@hotmail.com	
" License:	This file is placed in the public domain.

scriptencoding utf-8

function! pythonfunctionset#pythonprint(str)
	if has('python') == 0 && has('python3') == 0 
		return	
	endif
python << EOF
import vim
print( "this is python module --> " + vim.eval("a:str") )
EOF
endfunction

function! pythonfunctionset#pythonadd(x,y)
	if has('python') == 0 && has('python3') == 0 
		return	
	endif
python << EOF
import vim
px = vim.eval('a:x')
py = vim.eval('a:y')
result = int(px) + int(py)
print( "this is python module --> " + result )
EOF
	return result 
endfunction
