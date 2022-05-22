local cmd = vim.cmd             -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options
-- Направление перевода с русского на английский
g.translate_source = 'ru'
g.translate_target = 'en'
-- Компактный вид у тагбара и Отк. сортировка по имени у тагбара
g.tagbar_compact = 1
g.tagbar_sort = 0
-- Конфиг ale + eslint
g.ale_fixers = { javascript= { 'eslint' } }
-- g.ale_linters = { javascript= { 'eslint'  }  }
-- g.ale_linters_explicit = 1
g.ale_sign_error = '❌ '
g.ale_sign_warning = '⚠️'
g.ale_fix_on_save = 1
g.ale_lint_on_text_changed = 0
g.ale_lint_on_insert_leave = 0
g.ale_lint_on_enter = 0
-- Для этого есть другой плагин. Для автодополнения
g.ale_completion_enabled = 0
-- Чтобы показывал ошибки ale trauble
g.ale_set_loclist = 0
g.ale_set_quickfix = 1
-- fzf --
g.fzf_buffers_jump = 1
-- ack --
g.ackprg = 'ag --vimgrep'
-----------------------------------------------------------
-- Главные
-----------------------------------------------------------
opt.mouse = 'a'                     -- Вкл. мышка
opt.colorcolumn = '80'              -- Разделитель на 80 символов
opt.cursorline = true               -- Подсветка строки с курсором
opt.spelllang= { 'en_us', 'ru' }    -- Словари рус eng
opt.number = true                   -- Включаем нумерацию строк
opt.relativenumber = true           -- Вкл. относительную нумерацию строк
opt.so=999                          -- Курсор всегда в центре экрана
opt.undofile = true                 -- Возможность отката назад
opt.splitright = true               -- vertical split вправо
opt.splitbelow = true               -- horizontal split вниз
-- opt.keymap = 'russian-jcukenwin'
vim.cmd('set noswapfile')
-----------------------------------------------------------
-- Цветовая схема
-----------------------------------------------------------
opt.termguicolors = true      --  24-bit RGB colors
cmd'colorscheme onedark'
-- g.onedark_style = 'darker'
-- cmd'colorscheme challenger_deep'
-----------------------------------------------------------
-- Табы и отступы
-----------------------------------------------------------
cmd([[
filetype indent plugin on
syntax enable
]])
opt.expandtab = true      -- use spaces instead of tabs
opt.shiftwidth = 4        -- shift 4 spaces when tab
opt.tabstop = 4           -- 1 tab == 4 spaces
opt.smartindent = true    -- autoindent new lines
-- don't auto commenting new lines
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]
-- remove line lenght marker for selected filetypes
cmd [[autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0]]
-- 2 spaces for selected filetypes
cmd [[
autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml,htmljinja,jinja.html setlocal shiftwidth=2 tabstop=2
]]
-- С этой строкой отлично форматирует html файл, который содержит jinja2
-- cmd[[ autocmd BufNewFile,BufRead *.html set filetype=htmldjango ]]
-----------------------------------------------------------
-- Полезные фишки
-----------------------------------------------------------
-- Запоминает где nvim последний раз редактировал файл
cmd [[
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]]
-- Подсвечивает на доли секунды скопированную часть текста
exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup end
]], false)
-- tagbar автостарт для некоторых типов --
cmd [[autocmd VimEnter *.py,*.pl,*.js,*.php TagbarToggle]]
-----------------------------------------------------------
-- Установки для плагинов
-----------------------------------------------------------
-- require'trouble'.setup { mode='lsp_document_diagnostics'}
-- Lualine по умолчанию она не показывает ошибки, которые нашел линтер от ale
require'lualine'.setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = '
                    useLibraryCodeForTypes = false,
                    reportOptionalMemberAccess= false,
                    reportUnusedFunction= false,
                    reportFunctionMemberAccess= false,
                }
            },
        }
    end
    server:setup(opts)
end)
-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
vim.o.completeopt = 'menuone,noselect'
-- luasnip setup
local luasnip = require 'luasnip'
-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer', options = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end
        },
    },
},
}
-- diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false
})
-- Design
cmd 'sign define LspDiagnosticsSignError text='
cmd 'sign define LspDiagnosticsSignWarning text=ﰣ'
cmd 'sign define LspDiagnosticsSignInformation text='
cmd 'sign define LspDiagnosticsSignHint text='
-- show line diagnostic
-- vim.api.nvim_command(
-- 'autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })')
require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "maintained",
    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- List of parsers to ignore installing
    --[[    ignore_install = { "javascript" }, ]]
    highlight = {
        -- `false` will disable the whole extension
        enable = true,
        -- list of language that will be disabled
        -- disable = { "c", "rust" },
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}
