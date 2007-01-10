" Vim plugin for typing Esperanto text in a natural way (also Volapük gratis)

" Maintainer:    Cyril Slobin (no email for now)
" Last change:   2006 Oct 16
" Documentation: See file conlangs.txt

" $Id: conlangs.vim 1.3 2006/10/16 13:42:19 slobin Exp $

" Public Domain
" Made on Earth

scriptencoding utf-8

if &cp || &enc != "utf-8" || exists("g:loaded_conlangs")
  finish
endif
let g:loaded_conlangs = 1

let s:save_cpo = &cpo
set cpo&vim

command -nargs=? Esperanto call s:Esperanto(<q-args>)
command -nargs=? Volapuk call s:Volapuk(<q-args>)

function s:Esperanto(flag)
  if a:flag == "on"
    let s:esperanto = 1
    imap x <C-R>=<SID>Process("x")<CR>
    imap X <C-R>=<SID>Process("X")<CR>
  elseif a:flag == "off"
    unlet s:esperanto
    iunmap x
    iunmap X
  else
    echo "Esperanto is" exists("s:esperanto") ? "on" : "off"
  endif
endfunction

function s:Volapuk(flag)
  if a:flag == "on"
    let s:volapuk = 1
    imap : <C-R>=<SID>Process(":")<CR>
  elseif a:flag == "off"
    unlet s:volapuk
    iunmap :
  else
    echo "Volapuk is" exists("s:volapuk") ? "on" : "off"
  endif
endfunction

function <SID>Process(char)
  let [buf, row, col, off] = getpos(".")
  let [whole, before, old, after; rest] =
  \ matchlist(getline("."), printf('^\(.\{-}\)\(.\?\)\%%%dc\(.*\)$', col))
  let new = get(s:table[a:char], old, old . a:char)
  let col = col - strlen(old) + strlen(new)
  call setline(".", before . new . after)
  call setpos(".", [buf, row, col, off])
  return ""
endfunction

let s:table = {}
let s:table["x"] = {"C": "Ĉ", "c": "ĉ", "G": "Ĝ", "g": "ĝ", "H": "Ĥ", "h": "ĥ",
                   \"J": "Ĵ", "j": "ĵ", "S": "Ŝ", "s": "ŝ", "U": "Ŭ", "u": "ŭ"}
let s:table["X"] = copy(s:table["x"])
let s:table[":"] = {"A": "Ä", "a": "ä", "O": "Ö", "o": "ö", "U": "Ü", "u": "ü"}

for s:char in keys(s:table)
  for [s:key, s:val] in items(s:table[s:char])
    let s:table[s:char][s:val] = s:key . s:char
  endfor
endfor

let &cpo = s:save_cpo
