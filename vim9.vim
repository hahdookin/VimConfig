vim9script

def CheckBlame(): list<string>
    const lnum = getpos('.')[1]
    const filename = system("git ls-files --full-name " .. expand("%:t"))
    const cmd = printf("git log -L %d,%d:%s", lnum, lnum, filename)
    const lines = systemlist(cmd)
    return lines
enddef

nnoremap <leader>gb <ScriptCmd>popup_atcursor(CheckBlame(), {})<CR>
