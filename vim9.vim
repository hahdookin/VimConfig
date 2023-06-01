vim9script

def GetDirectories(path: string, count: number): any
    final dirs = []
    for i in range(1, count)
        const dir = fnamemodify(path, $":p{repeat(':h', i)}:t")
        dirs->add(dir)
        if dir == ''
            return dirs
        endif
    endfor
    return dirs->reverse()
enddef

def GetDirectoriesWithFilename(path: string, count: number): string
    if count == 0
        return fnamemodify(path, ':t')
    endif
    return GetDirectories(path, count)->join('/') .. '/' .. fnamemodify(path, ':t')
enddef

def g:GetShortFilePath(filename: string, filenames: list<string>): any
    var working_filename = filename
    # Check if this path is in the list, just written different
    for fname in filenames
        if fnamemodify(fname, ":p") == fnamemodify(filename, ":p")
            working_filename = fname
        endif
    endfor
    final counts = {}
    for fname in filenames
        if fname != working_filename
            counts[fname] = 0
        endif
    endfor
    var keep_going = true

    var iters = 0
    while keep_going
        keep_going = false
        for fname in filenames
            if fname == working_filename || !counts->has_key(fname) | continue | endif
            var a = GetDirectoriesWithFilename(fname, iters)
            var b = GetDirectoriesWithFilename(working_filename, iters)
            if a == b
                iters += 1
                keep_going = true
            else
                counts->remove(fname)
            endif
        endfor
    endwhile

    return GetDirectoriesWithFilename(filename, iters)
enddef

g:lightline.component.filename = '%{g:GetShortFilePath(bufname(),getcompletion("", "buffer"))}'
g:lightline#init()
g:lightline#update()
