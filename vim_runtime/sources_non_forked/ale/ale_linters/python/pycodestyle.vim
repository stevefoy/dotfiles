" Author: Michael Thiesen <micthiesen@gmail.com>
" Description: pycodestyle linting for python files

call ale#Set('python_pycodestyle_executable', 'pycodestyle')
call ale#Set('python_pycodestyle_options', '')
call ale#Set('python_pycodestyle_use_global', 0)

function! ale_linters#python#pycodestyle#GetExecutable(buffer) abort
    return ale#python#FindExecutable(a:buffer, 'python_pycodestyle', ['pycodestyle'])
endfunction

function! ale_linters#python#pycodestyle#GetCommand(buffer) abort
    return ale#Escape(ale_linters#python#pycodestyle#GetExecutable(a:buffer))
    \   . ' '
    \   . ale#Var(a:buffer, 'python_pycodestyle_options')
    \   . ' -'
endfunction

function! ale_linters#python#pycodestyle#Handle(buffer, lines) abort
    let l:pattern = '\v^(\S*):(\d*):(\d*): ([EW]\d+) (.*)$'
    let l:output = []

    " lines are formatted as follows:
    " file.py:21:26: W291 trailing whitespace
    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        if(l:match[4] is# 'W291' || l:match[4] is# 'W293')
        \&& !ale#Var(a:buffer, 'warn_about_trailing_whitespace')
            " Skip warnings for trailing whitespace if the option is off.
            continue
        endif

        if l:match[4] is# 'W391'
        \&& !ale#Var(a:buffer, 'warn_about_trailing_blank_lines')
            " Skip warnings for trailing blank lines if the option is off
            continue
        endif

        let l:item = {
        \   'lnum': l:match[2] + 0,
        \   'col': l:match[3] + 0,
        \   'type': l:match[4][0],
        \   'sub_type': 'style',
        \   'text': l:match[5],
        \   'code': l:match[4],
        \}

        " E999 and E112 are syntax errors.
        if l:match[4] is# 'E999' || l:match[4] is# 'E112'
            unlet l:item.sub_type
        endif

        call add(l:output, l:item)
    endfor

    return l:output
endfunction

call ale#linter#Define('python', {
\   'name': 'pycodestyle',
\   'executable_callback': 'ale_linters#python#pycodestyle#GetExecutable',
\   'command_callback': 'ale_linters#python#pycodestyle#GetCommand',
\   'callback': 'ale_linters#python#pycodestyle#Handle',
\})
