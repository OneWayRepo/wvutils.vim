syn match LedgerKeyword "￥"
syn match LedgerKeyword "include"
syn region Comment start=";"  end="\n"
syn region LedgerPayee matchgroup=LedgerKeyword start="*" end="$" skip="*" 
syn region Comment start="comment" end="end comment"
syn match LedgerAccountKeyword ":"
syn match LedgerDate '\d\{4}/[0-1][0-9]/[0-3][0-9]'
