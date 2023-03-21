vim9script

def CheckBlame(): list<string>
    const lnum = getpos('.')[1]
    const filename = system("git ls-files --full-name " .. expand("%:t"))
    const cmd = printf("git log -L %d,%d:%s", lnum, lnum, filename)
    const lines = systemlist(cmd)
    var winid = popup_atcursor(lines, {border: []})
	setbufvar(winbufnr(winid), '&filetype', 'git')
    return lines
enddef

nnoremap <leader>gb <ScriptCmd>CheckBlame()<CR>

# Toggle preview window
def PreviewWindow(): dict<any>
    final self: dict<any> = { 
        winid: 0
    }

    self.Open = () => {
        :10split
        self.winid = win_getid()
        setwinvar(winnr(), "&winfixheight", 1)
    }
    self.Close = () => {
        win_execute(self.winid, "close")
        self.winid = 0
    }
    self.Toggle = () => {
        if self.winid == 0
            self.Open()
        else
            self.Close()
        endif
    }

    return self
enddef
var preview_window = PreviewWindow()
nnoremap <leader>cp <ScriptCmd>preview_window.Toggle()<CR>

# Use popup window for quickfix
def CycleQf(n: number, relative: number = 0)
    var cur_index = getqflist({idx: 0})['idx']
    cur_index = relative ? cur_index + n : n
    setqflist([], 'a', {idx: cur_index})

    var qflist = getqflist()
    popup_clear()
    if qflist->len() == 0 || qflist->len() <= cur_index
        return
    endif
    var cur_entry = getqflist()[cur_index - 1]
    var popup_options = { 
        maxheight: 10, 
        firstline: cur_entry.lnum, 
        border: [], 
        title: bufname(cur_entry.bufnr)
    }
    var winid = popup_atcursor(cur_entry.bufnr, popup_options)
    var bufnr = winbufnr(winid)
    setwinvar(winid, '&number', 1)
enddef
noremap <leader>hh <ScriptCmd>CycleQf(-1, 1)<CR>
noremap <leader>ll <ScriptCmd>CycleQf(1, 1)<CR>
autocmd BufReadPost quickfix nnoremap <buffer> <S-CR> :call CycleQf(line('.'))<CR>

