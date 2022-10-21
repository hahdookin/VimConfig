vim9script

def CheckBlame(): list<string>
    const lnum = getpos('.')[1]
    const filename = system("git ls-files --full-name " .. expand("%:t"))
    const cmd = printf("git log -L %d,%d:%s", lnum, lnum, filename)
    return systemlist(cmd)
enddef

nnoremap <leader>bb <ScriptCmd>popup_atcursor(CheckBlame(), {})<CR>
