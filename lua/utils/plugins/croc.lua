local uv = vim.loop
local croc = {}

-- @handle : A handle to the subprocess
-- helper function safe_close which is used to close a handle only if it is
-- not already closing, this is used to avoid any errors while freeing up resources
local function safe_close(handle)
    if not vim.loop.is_closing(handle) then
        vim.loop.close(handle)
    end
end
-- @cmd: A string representing the command to be run in the subprocess.
-- @opts: A table containing options to be passed to the vim.loop.spawn function when creating the subprocess.
-- @input: A table containing two functions stdout and stderr which will be used as the handlers for data received
-- from the standard output and standard error streams of the subprocess respectively.
-- @onexit: A function that will be called when the subprocess terminates, it takes two parameters code and signal
-- which represent the exit code and the signal that caused the subprocess to terminate respectively.
local function spawn(cmd, opts, input, onexit)
    local handle
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local args = vim.tbl_extend("force", opts, { stdio = { nil, stdout, stderr } })

    handle, _ = vim.loop.spawn(cmd, args, function(code, signal)
        onexit(code, signal)
        vim.loop.read_stop(stdout)
        vim.loop.read_stop(stderr)
        safe_close(handle)
        safe_close(stdout)
        safe_close(stderr)
    end)

    vim.loop.read_start(stdout, input.stdout)
    vim.loop.read_start(stderr, input.stderr)

    local function stop()
        vim.loop.read_stop(stdout)
        vim.loop.read_stop(stderr)

        vim.schedule_wrap(function()
            vim.loop.process_kill(handle)
            safe_close(stdout)
            safe_close(stderr)
        end)
    end
    return stop
end

-- @filepath: A string representing the path of the file to be parsed, if not specified it will default to the
-- current file in the editor.
-- @basedir: A string representing the base directory from which the croc command will be executed, if not
-- specified it will default to the current working directory.
-- @on_complete: A function that will be called when the croc process terminates, it takes in two parameters
-- data and stderr which represent the return value of the process and any error messages generated by the process respectively.
local function croc_parser(filepath, basedir, on_complete)
    basedir = basedir or vim.fn.getcwd()
    on_complete = on_complete or function(data)
        P(data)
    end

    local initial_code = true
    local stderr = ""
    local args = {
        "send",
        filepath or vim.fn.expand("%"),
    }
    local done = false
    local stop
    stop = spawn("croc", { args = args, cwd = basedir }, {
        stdout = function(_, chunk)
            if chunk then
                P(chunk)
            end
        end,
        stderr = function(s, data)
            stderr = stderr .. "\n" .. (data or s or "")
            local pattern = "%d%d%d%d%-%a+%-%a+%-%a+"
            local code = string.match(stderr, pattern)
            if code and initial_code then
                vim.schedule(function()
                    vim.notify("Code: " .. code, vim.log.levels.INFO, { timeout = 5000 })
                    vim.fn.setreg("+", code)
                    initial_code = false
                end)
            else
                --  TODO: (vsedov) (07:57:07 - 09/02/23): Make a temp buffer that contains the next
                --  outputs
            end
        end,
    }, function(_, return_val)
        return vim.schedule(function()
            vim.notify("Shutting down")
            on_complete(done and 0 or return_val, stderr)
        end)
    end)

    -- My brain went poof, perhaps some table magic ?
    lambda.command("CrocStop", function()
        stop()
        if filepath then
            os.remove(filepath)
        end
        vim.schedule_wrap(function()
            vim.api.nvim_del_user_command("CrocStop")
        end)
    end, { force = true })
end

function paste_croc(args)
    local pattern = "%d%d%d%d%-%a+%-%a+%-%a+"
    code = args.args
    if not string.match(code, pattern) then
        vim.notify("Invalid code", vim.log.levels.ERROR, { timeout = 5000 })
        return
    end
    os.execute("croc --yes " .. code)
end

function send_visual(content, filename)
    filename = filename .. "." .. vim.bo.filetype
    filename = "/tmp/" .. filename
    file = io.open(filename, "w")
    io.output(file)
    for k, v in ipairs(content) do
        io.write(v, "\n")
    end
    io.close(file)

    croc_parser(filename)
end

function send_croc(args)
    if args.range == 0 then
        croc_parser()
    else
        send_visual(vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, false), args.args)
    end
end

function croc.setup()
    vim.api.nvim_create_user_command("CrocSend", function(args)
        args = args or {}
        send_croc(args)
    end, { nargs = "*", range = true })

    vim.api.nvim_create_user_command("CrocPaste", function(args)
        args = args or vim.fn.getreg("+")
        paste_croc(args)
    end, { nargs = "*", range = true })
end

return croc
