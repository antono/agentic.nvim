local States = require("agentic.states")

--- Neovim completion item structure (vim.fn.complete() dictionary format)
--- For complete list of properties, see |complete-items| in insert.txt help manual
--- @class agentic.acp.CompletionItem
--- @field word string The text to insert (mandatory)
--- @field menu string Description shown in completion menu
--- @field info string Full description shown in popup window
--- @field kind string Type/category of completion item
--- @field icase number 1 for case-insensitive, 0 for case-sensitive

--- @class agentic.acp.SlashCommands
local SlashCommands = {}

--- Replace all commands with new list in completion format
--- Validates each command has required fields, skips invalid commands and commands with spaces
--- Filters out `clear` command (handled by specific agents internally)
--- Automatically adds `/new` command if not provided by agent
--- @param bufnr integer
--- @param available_commands agentic.acp.AvailableCommand[]
function SlashCommands.setCommands(bufnr, available_commands)
    --- @type agentic.acp.CompletionItem[]
    local commands = {}

    local has_new_command = false

    for _, cmd in ipairs(available_commands) do
        if
            cmd.name
            and cmd.description
            and not cmd.name:match("%s")
            and cmd.name ~= "clear"
        then
            if cmd.name == "new" then
                has_new_command = true
            end

            --- @type agentic.acp.CompletionItem
            local completion_item = {
                word = cmd.name,
                menu = cmd.description,
                info = cmd.description,
                kind = "/",
                icase = 1,
            }
            table.insert(commands, completion_item)
        end
    end

    -- Add /new command if not provided by agent
    if not has_new_command then
        --- @type agentic.acp.CompletionItem
        local new_command = {
            word = "new",
            menu = "Start a new session",
            info = "Start a new session",
            kind = "/",
            icase = 1,
        }
        table.insert(commands, new_command)
    end

    -- must be set at the end, as it gets serialized and loses the reference
    States.setSlashCommands(bufnr, commands)
end

--- Get list of files in current directory for file completion
--- @return string[] files List of filenames in current directory
local function get_file_list()
    local handle = io.popen("ls -1 2>/dev/null")
    if not handle then
        return {}
    end
    local files = {}
    for line in handle:lines() do
        table.insert(files, line)
    end
    handle:close()
    return files
end

--- Setup slash command and file reference selection via vim.ui.select()
--- Uses TextChangedI to detect when `/` is typed at prompt start OR `@` anywhere in the line
--- Users with dressing.nvim or telescope-ui-select.nvim get enhanced UI automatically
--- @param bufnr integer The input buffer number
function SlashCommands.setup_completion(bufnr)
    vim.api.nvim_create_autocmd("TextChangedI", {
        buffer = bufnr,
        callback = function()
            local commands = States.getSlashCommands()

            local cursor = vim.api.nvim_win_get_cursor(0)
            local row = cursor[1]
            local col = cursor[2]

            if row ~= 1 or col < 1 then
                return
            end

            local line = vim.api.nvim_get_current_line()

            -- Check for @ at cursor position (just typed) for file completion
            -- Only trigger when @ is the last character typed (cursor right after @)
            local at_pos = line:find("@", 1, true)
            if at_pos and col == at_pos + 1 then
                local files = get_file_list()
                if #files == 0 then
                    return
                end

                -- Clear the line to prevent the "@" from appearing again
                vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "" })

                vim.ui.select(files, {
                    prompt = "Select file:",
                }, function(choice)
                    if choice then
                        local file_ref = "@" .. choice
                        vim.api.nvim_buf_set_lines(
                            bufnr,
                            0,
                            1,
                            false,
                            { file_ref }
                        )
                        vim.api.nvim_win_set_cursor(0, { 1, #file_ref + 1 })
                        vim.cmd("startinsert!")
                    else
                        -- Restore the @ that was in the line
                        if at_pos then
                            vim.api.nvim_buf_set_lines(
                                bufnr,
                                0,
                                1,
                                false,
                                { string.rep(" ", at_pos - 1) .. "@" }
                            )
                            vim.api.nvim_win_set_cursor(0, { 1, at_pos + 1 })
                            vim.cmd("startinsert!")
                        end
                    end
                end)
                return
            end

            -- Slash commands only at line start
            if #commands == 0 or not line:match("^/") or line:match("%s") then
                return
            end

            -- Clear the line to prevent the "/" from appearing again
            vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "" })

            vim.ui.select(commands, {
                prompt = "Select slash command:",
                format_item = function(item)
                    return item.word .. " - " .. item.menu
                end,
            }, function(choice)
                if choice then
                    local command = "/" .. choice.word
                    vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { command })
                    vim.api.nvim_win_set_cursor(0, { 1, #command + 1 })
                    vim.cmd("startinsert!")
                else
                    vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "/" })
                end
            end)
        end,
    })
end

--- Completion function for completefunc
--- @param findstart number 1 to find start of completion, 0 to return matches
--- @param _base string The text to match when findstart=0
--- @return number|table Start column when findstart=1, completion items when findstart=0
function SlashCommands.complete_func(findstart, _base)
    if findstart == 1 then
        -- Return the column where the completion starts (after the "/")
        return 1
    end

    return States.getSlashCommands()
end

return SlashCommands
