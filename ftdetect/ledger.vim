" 声明一个ledger的类型
" 注意放在ftdetect目录下的文件，文件类型可以被自动识别
" 运行 : set filetype    可以查看当前的文件类型 
" Last Change:	2019.03.15
" Maintainer:   kevin.wang kevin.wang2004@hotmail.com	
" License:	This file is placed in the public domain.
augroup ledgerautocmd 
autocmd!
au! BufRead,BufNewFile *.ldg	setfiletype ledger
au! VimEnter *.ldg	colorschem ledgercolor
augroup END
