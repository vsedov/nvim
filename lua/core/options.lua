local global = require("core.global")

local function load_options()
    local global_local = {
        guifont = "Operator Mono Ssm Lib Book:h10",
        termguicolors = true,
        mouse = "nv",
        errorbells = true,
        visualbell = true,
        hidden = true,
        fileformats = "unix,mac,dos",
        magic = true,
        -- autochdir = true, -- keep pwd the same as current buffer
        virtualedit = "block",
        encoding = "utf-8",
        viewoptions = "folds,cursor,curdir,slash,unix",
        sessionoptions = "buffers,curdir,folds,winpos,winsize",
        clipboard = "unnamedplus",
        wildignorecase = true,
        wildignore = ".git/**,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
        backup = false,
        writebackup = false,
        undofile = true,
        swapfile = true,
        directory = global.cache_dir .. "swag/",
        undodir = global.cache_dir .. "undo/",
        backupdir = global.cache_dir .. "backup/",
        viewdir = global.cache_dir .. "view/",
        history = 2000,
        shada = "!,'300,<50,@100,s10,h",
        backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
        smarttab = true,
        smartindent = true,
        shiftround = true,
        timeout = true,
        ttimeout = true,
        timeoutlen = 500,
        ttimeoutlen = 10,
        updatetime = 300,
        redrawtime = 5000,
        ignorecase = true,
        smartcase = true,
        infercase = true,
        incsearch = true,
        wrapscan = true,
        complete = ".,w,b,k",
        inccommand = "nosplit", --split
        grepformat = "%f:%l:%c:%m",
        grepprg = 'rg --hidden --vimgrep --smart-case --glob "!{.git,node_modules,*~}/*" --',
        breakat = [[\ \ ;:,!?]],
        startofline = false,
        whichwrap = "h,l,<,>,[,],~",
        splitbelow = true,
        splitright = true,
        eadirection = "hor",

        switchbuf = "useopen,uselast",
        backspace = "indent,eol,start",
        --        diffopt = "filler,hiddenoff,closeoff,iwhite,internal,algorithm:patience",
        diffopt = vim.opt.diffopt + {
            "vertical",
            "iwhite",
            "hiddenoff",
            "foldcolumn:0",
            "context:4",
            "algorithm:histogram",
            "indent-heuristic",
        },
        cscopequickfix = "s-,c-,d-,i-,t-,e-,a-",
        completeopt = "menuone,noselect",
        jumpoptions = "stack",
        showmode = false,
        shortmess = "aotTIcF",
        scrolloff = 2,
        sidescrolloff = 5,
        foldlevelstart = 99,
        foldexpr = "nvim_treesitter#foldexpr()",
        ruler = false,
        list = true,
        mousefocus = true,
        mousescroll = "ver:2,hor:6",
        showtabline = 2,
        winwidth = 30,
        winminwidth = 10,
        pumheight = 15,
        helpheight = 12,
        previewheight = 12,
        showcmd = false,
        cmdheight = 1,
        cmdwinheight = 5,
        equalalways = false,
        laststatus = 3,
        display = "lastline",
        showbreak = "﬌  ", --↳
        pumblend = 10,
        winblend = 10,
        syntax = "off",
        background = "dark",

        synmaxcol = 1024,
        formatoptions = "1jcroql",
        textwidth = 80,
        expandtab = true,
        autoindent = true,
        tabstop = 2,
        shiftwidth = 2,
        softtabstop = -1,
        breakindentopt = "shift:2,min:20",
        wrap = false,
        linebreak = true,
        number = true,
        colorcolumn = "80",
        foldenable = true,
        signcolumn = "yes:3", --[auto yes] yes:3  auto:2  "number" auto: 2-4
        conceallevel = 2,
        concealcursor = "niv",
        foldcolumn = "1", -- nice folds
        fillchars = {
            eob = " ",
            -- vert = "║",
            -- horiz = "═",
            -- horizup = "╩",
            -- horizdown = "╦",
            -- vertleft = "╣",
            -- vertright = "╠",
            -- verthoriz = "╬",
            horiz = "━",
            horizup = "┻",
            horizdown = "┳",
            vert = "┃",
            vertleft = "┫",
            vertright = "┣",

            -- horiz = "━",
            -- horizup = "┻",
            -- horizdown = "┳",
            -- vert = "┃",
            -- vertleft = "┫",
            -- vertright = "┣",
            -- verthoriz = "╋",

            fold = " ",
            foldopen = "",
            -- foldsep = " ",
            foldclose = "",
        },
        listchars = {
            eol = nil,
            tab = "│ ",
            extends = "›", -- Alternatives: … »
            precedes = "‹", -- Alternatives: … «
            trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
        },
        spellfile = global.home .. ".config/nvim/spell/en.utf-8.add",
        spellcapcheck = "",
        spelllang = "en_gb,programming",
        secure = true,
        exrc = true,
    }

    if global.is_mac then
        vim.g.clipboard = {
            name = "macOS-clipboard",
            copy = {
                ["+"] = "pbcopy",
                ["*"] = "pbcopy",
            },
            paste = {
                ["+"] = "pbpaste",
                ["*"] = "pbpaste",
            },
            cache_enabled = 0,
        }
        vim.g.python_host_prog = "/usr/bin/python2"
        vim.g.python3_host_prog = "/usr/bin/python3"
        if vim.fn.exists("$VIRTUAL_ENV") == 1 then
            vim.g.python3_host_prog =
                vim.fn.substitute(vim.fn.system("which -a python3 | head -n2 | tail -n1"), "\n", "", "g")
        else
            vim.g.python3_host_prog = vim.fn.substitute(vim.fn.system("which python3"), "\n", "", "g")
        end
    end

    for name, value in pairs(global_local) do
        vim.opt[name] = value
    end
end

if vim.fn.executable("nvr") > 0 then
    vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
    vim.env.EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

vim.opt.spelloptions:append({ "camel", "noplainbuffer" })
vim.opt.jumpoptions:append({ "view" })
vim.g.python_host_prog = "/usr/bin/python2"
vim.g.python3_host_prog = "/usr/bin/python3"
vim.cmd([[syntax off]])
vim.cmd([[set viminfo-=:42 | set viminfo+=:1000]])
load_options()
