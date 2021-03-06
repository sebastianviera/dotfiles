scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V)
	let s:Undofile = a:V.import("Unlocker.Holder.Buffer.Undofile")
	let s:Option   = a:V.import("Unlocker.Holder.Option")
	let s:Base = a:V.import("Unlocker.Rocker.HolderBase")
endfunction


function! s:_vital_depends()
	return [
\		"Unlocker.Holder.Buffer.Undofile",
\		"Unlocker.Rocker.HolderBase",
\	]
endfunction


let s:obj = {}

function! s:obj.lock()
	if undotree().seq_last == 0
		call self.__undolevels.lock()
		let &l:undolevels = -1
	else
		call self.__undofile.lock()
	endif
	return self
endfunction


function! s:obj.unlock()
	call self.__undolevels.unlock()
	try
		call self.__undofile.unlock()
	catch /^Vim\%((\a\+)\)\=:E605/
	endtry
	return self
endfunction


function! s:obj.relock()
	call self.unlock()
	call self.lock()
endfunction


function! s:make()
	let result = deepcopy(s:obj)
	let result.__undolevels = s:Base.make(s:Option.make("&l:undolevels"))
	let result.__undofile = s:Base.make(s:Undofile.make())
	return result
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
