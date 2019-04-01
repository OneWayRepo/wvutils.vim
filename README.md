# wvutils.vim
该工程的最大目的就是通过一个vimscript插件的编写，来熟悉vimscript脚本的语法。


1.记录的是学习vimscript脚本的过程中积累的知识
1.1.	学习网站
http://www.treelib.com/book-detail-id-47-aid-2896.html

1.2 	变量说明
"“$”——访问环境变量；
"“&”——访问 Vim 选项；
"“@”——访问寄存器。

"“b:”——只对当前缓冲区（buffer）有效的变量；
"“w:”——只对当前编辑窗口（window）有效的变量。
"“g:”——全局变量（在函数中访问全局变量必须使用该前缀，不加前缀的话则认为是函数内的局部变量）；
"“s:”——变量名只在当前脚本中有效；
"“a:”——函数的参数；
"“v:”——Vim 内部预定义的特殊变量（参见“:help vim-variable”）。

1.3 	在normal状态下的文档操作
" 这条语句很重要，在当前状态下，
"execute 'normal ' . 'G'
"execute 'normal ' . '$a' . '句子尾部加入'

1.4	各个插件目录下子目录的功能

1.4.1 ~/.vim/colors/
Vim将会查找~/.vim/colors/mycolors.vim并执行它。 这个文件应该包括生成你的配色方案所需的一切Vimscript命令。

~/.vim/plugin/
~/.vim/plugin/下的文件将在每次Vim启动的时候执行。 这里的文件包括那些无论何时，在启动Vim之后你就想加载的代码。

~/.vim/ftdetect/
~/.vim/ftdetect/下的文件在每次你启动Vim的时候也会执行。

ftdetect是"filetype detection"的缩写。 这里的文件仅仅负责启动检测和设置文件的filetype类型的自动命令。 这意味着它们一般不会超过一两行。

~/.vim/ftplugin/
~/.vim/ftplugin/下的文件则各不相同。

一切皆取决于它的名字!当Vim把一个缓冲区的filetype设置成某个值时， 它会去查找~/.vim/ftplugin/下对应的文件。 比如：如果你执行set filetype=derp，Vim将查找~/.vim/ftplugin/derp.vim。 一旦文件存在，Vim将执行它。

Vim也支持在~/.vim/ftplugin/下放置文件夹。 再以我们刚才的例子为例：set filetype=derp将告诉Vim去执行~/.vim/ftplugin/derp/下的全部 "*.vim"
*.vim文件。 这使得你可以按代码逻辑分割在ftplugin下的文件。

因为每次在一个缓冲区中执行filetype时都会执行这些文件，所以它们只能设置buffer-local选项！ 如果在它们中设置了全局选项，所有打开的缓冲区的设置都会遭到覆盖！

~/.vim/indent/
~/.vim/indent/下的文件类似于ftplugin下的文件。加载时也是只加载名字对应的文件。

indent文件应该设置跟对应文件类型相关的缩进，而且这些设置应该是buffer-local的。

是的，你当然可以把这些代码也一并放入ftplugin文件， 但最好把它们独立出来，让其他Vim用户理解你的意图。这只是一种惯例，不过请尽量体贴用户并遵从它。

~/.vim/compiler/
~/.vim/compiler下的文件非常类似于indent文件。它们应该设置同类型名的当前缓冲区下的编译器相关选项。

不要担心不懂什么是"编译器相关选项"。我们等会会解释。

~/.vim/after/
~/.vim/after文件夹有点神奇。这个文件夹下的文件会在每次Vim启动的时候加载， 不过是在~/.vim/plugin/下的文件加载了之后。

这允许你覆盖Vim的默认设置。实际上你将很少需要这么做，所以不用理它， 除非你有"Vim设置了选项x，但我想要不同的设置"的主意。

~/.vim/autoload/
~/.vim/autoload文件夹就更加神奇了。事实上它的作用没有听起来那么复杂。

简明扼要地说：autoload是一种延迟插件代码到需要时才加载的方法。 我们将在重构插件的时候详细讲解并展示它的用法。

~/.vim/doc/

1.5 vim脚本语法
1.5.1
" 休眠时间，以毫秒计算
"sleep 40m

1.5.2
" 得到一个临时文件的名称
"let s:tmpfile = tempname()
"call minifuctionsets#version('生产一个临时文件：'.s:tmpfile,0)
