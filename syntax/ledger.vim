syn match LedgerKeyword "￥"
syn match LedgerKeyword "include"
syn match LedgerKeyword "apply"
syn match LedgerKeyword "tag"
syn match LedgerKeyword "end"
syn match LedgerKeyword "account"
syn match LedgerKeyword "commodity"
syn region Comment start=";" end="$"
syn region LedgerPlus start="￥" end="$" contains=AAA
syn region LedgerMinus start="￥-" end="$" contains=AAA
syn match AAA ")"
syn region LedgerPayee matchgroup=LedgerKeyword start="*" end="$" skip="*" 
syn region Comment start="comment" end="end comment"
syn match LedgerAccountKeyword ":"
syn match LedgerDate '\d\{4}/[0-1][0-9]/[0-3][0-9]'
