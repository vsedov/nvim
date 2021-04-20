source  $HOME/.config/nvim/config/execution.vim
source  $HOME/.config/nvim/config/main.vim
source  $HOME/.config/nvim/config/plugins.vim
source  $HOME/.config/nvim/config/most_mappings.vim

source  $HOME/.config/nvim/config/autogroup.vim
source  $HOME/.config/nvim/config/functions.vim
source  $HOME/.config/nvim/config/plugin_settings.vim
source  $HOME/.config/nvim/config/ale.vim


source  $HOME/.config/nvim/config/dashboard.vim
source  $HOME/.config/nvim/config/floatterm.vim
source  $HOME/.config/nvim/config/coc.vim
source  $HOME/.config/nvim/config/ui.vim
source  $HOME/.config/nvim/config/betterescape.vim

source  $HOME/.config/nvim/config/pythonmanualdebug.vim
source  $HOME/.config/nvim/config/markdow_multicurse.vim
source  $HOME/.config/nvim/config/vimtex.vim
source  $HOME/.config/nvim/config/templates.vim
source  $HOME/.config/nvim/config/goyo.vim

source  $HOME/.config/nvim/config/gitfug.vim
source  $HOME/.config/nvim/config/debug_test.vim
source  $HOME/.config/nvim/config/chadtree.vim
source  $HOME/.config/nvim/config/undotree.vim

source  $HOME/.config/nvim/config/indent.vim
source  $HOME/.config/nvim/config/vista.vim
source  $HOME/.config/nvim/config/Vimjup.vim
source  $HOME/.config/nvim/config/snipdebugger.vim

source  $HOME/.config/nvim/config/breakhabits.vim
source  $HOME/.config/nvim/config/animation.vim
source  $HOME/.config/nvim/config/loading_java.vim
source  $HOME/.config/nvim/config/switch.vim




" theicfire .vimrc tips
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file


"
" Remove all trailing whitespace by pressing C-S
nnoremap <C-S> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
au BufEnter * if &buftype == 'terminal' | :startinsert | endif


map <F7> :let $VIM_DIR=expand('%:p:h')<CR>: vsplit term://zsh<CR>cd $VIM_DIR<CR>
nnoremap <silent> <F6> :Run <cr>

nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

let g:previous_window = -1
au BufEnter * call SmartInsert()


" Configuration example
"<C-w><C-p> this is to move to the next windw


"Fold
"LUA CONFIG STARTS HERE WILL HAVE TO AUTOLOAD THIS AS WELL > "

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lua << EOF
  require('galaxy')
  require('lsp')
  require('nvim-bufferline')
  require('plugins.telescope')
  require('telescope').load_extension('octo')
  require('telescope').load_extension('dap')
  require('dap-python').setup('/usr/bin/python3')
  require('dap-python').test_runner = 'pytest'
  require("dapui").setup()
  require('kommentary.config').use_extended_mappings()
  require('treesitter')
  require("telescope").load_extension("frecency")
  require('pattern')
  require('sagastuff')
  require('quickfix-bar')
  require('numb').setup()
EOF
" geometry configuration
lua require('nvim-peekup.config').geometry["height"] = 0.8
lua require('nvim-peekup.config').geometry["title"] = 'An awesome window title'


"behaviour of the peekup window on keystroke
lua require('nvim-peekup.config').on_keystroke["delay"] = '100ms'
"
lua require('nvim-peekup.config').on_keystroke["autoclose"] = false

hi TelescopeBorder         guifg=#8be9fd
hi TelescopePromptBorder   guifg=#50fa7b
hi TelescopePromptPrefix   guifg=#bd93f9

highlight BqfPreviewBorder guifg=#50a14f ctermfg=71
highlight link BqfPreviewRange IncSearch



"Lua Source Configs"
source  $HOME/.config/nvim/config/dapdebug.vim
source  $HOME/.config/nvim/config/telescopebinds.vim
source  $HOME/.config/nvim/config/saga.vim
source  $HOME/.config/nvim/config/peek.vim
source  $HOME/.config/nvim/config/bufferstuff.vim


command! Nani echo synIDattr(synID(line('.'), col('.'), 1), 'name')

""Help define what the bloody plugin value is
map <leader>hhi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>



""  require('quickfix-bar') - I think this is causing issues but eh cuase currently i sunkown 
" this does something i think 

lua << EOF

require('specs').setup{ 
    show_jumps  = true,
    min_jump = 30,
    popup = {
        fader = function(blend, cnt)
            if cnt > 100 then
                return 80
            else return nil end
        end,
        resizer = function(width, ccol, cnt)
            if width-cnt > 0 then
                return {width+cnt, ccol}
            else return nil end
        end,
    }
}
EOF



lua <<EOF
vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
EOF




lua <<EOF
require('bqf').setup({
    auto_enable = true,
    preview = {
      auto_preview = false,
    },
    
})
EOF

