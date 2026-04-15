# Change: Replace slash command completefunc with vim.ui.select()

## Why
Currently, slash commands (`/new`, `/edit`, etc.) use Neovim's native `completefunc` 
which shows a basic popup menu without preview capability. Using `vim.ui.select()` 
allows plugins like `dressing.nvim` or `telescope-ui-select.nvim` to provide a richer 
UI with previews, fuzzy matching, and better visual integration.

## What Changes
- Remove the `completefunc` setup in `slash_commands.lua`
- Replace with `vim.ui.select()` triggered by typing `/` at the start of the prompt
- The picker shows available slash commands with descriptions as selection options

## Impact
- Affected files: `lua/agentic/acp/slash_commands.lua`
- Affected specs: none (new feature, not covered by existing spec)
- Users with `dressing.nvim` or `telescope-ui-select.nvim` will automatically get 
  better UI
- Users without such plugins get the default Neovim `vim.ui.select()` UI