set number
set autoindent
set hlsearch!
set splitbelow
set splitright

" Set tab widths and insert spaces for tabs
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab


" Tab settings
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <S-Tab> <gv
nnoremap <Tab> >>_
vnoremap <Tab> >gv

" Default to vertical splits
set diffopt+=vertical
silent! set splitvertical
if v:errmsg != ''
    cabbrev split vert split
    cabbrev hsplit split
    cabbrev help vert help
    noremap <C-w>] :vert botright wincmd ]<CR>
    noremap <C-w><C-]> :vert botright wincmd ]<CR>
else
    cabbrev hsplit hor split
endif

cnoreabbrev <expr> help ((getcmdtype() is# ':'    && getcmdline() is# 'help')?('vert help'):('help'))
cnoreabbrev <expr> h ((getcmdtype() is# ':'    && getcmdline() is# 'h')?('vert help'):('h'))

" iToggle Vexplore with Ctrl-E
function! ToggleVExplorer()
	if exists("t:expl_buf_num")
        let expl_win_num = bufwinnr(t:expl_buf_num)
        if expl_win_num != -1
            let cur_win_nr = winnr()
	        exec expl_win_num . 'wincmd w'
	        close
	        exec cur_win_nr . 'wincmd w'
	        unlet t:expl_buf_num
	    else
	        unlet t:expl_buf_num
	    endif
	else
	    exec '1wincmd w'
	    Vexplore
	    let g:netrw_liststyle=3

	    let g:netrw_banner=0
	    let t:expl_buf_num = bufnr("%")
	endif
endfunction

map <silent> <C-E> :call ToggleVExplorer()<CR>

" Move Windows to tabs
function MoveToPrevTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif

    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')

    if tabpagenr() != 1
        close!

        if l:tab_nr == tabpagenr('$')
            tabprev
        endif

        vsplit
    else
        close!
        exe "0tabnew"
    endif

    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc

function MoveToNextTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
     endif

    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')

    if tabpagenr() < tab_nr
        close!
    
        if l:tab_nr == tabpagenr('$')
            tabnext
        endif

        vsplit
    else
        close!
        tabnew
    endif

    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc

map mt :call MoveToNextTab()<CR>
map mT :call MoveToPrevTab()<CR>
