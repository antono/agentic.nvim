# Tasks: Replace slash command completefunc with vim.ui.select() and add file completion

## 1. Implementation

- [x] 1.1 RED: Test that typing `/` at prompt start triggers command selection via vim.ui.select()
- [x] 1.2 GREEN: Modify `slash_commands.lua`:
      - Remove `completefunc` setup from `setup_completion()`
      - Remove `TextChangedI` autocmd
      - Add logic to detect `/` at line start (cursor position 0, char is "/")
      - Call `vim.ui.select()` with commands
- [x] 1.3 RED: Test selected command replaces the `/` prefix in prompt
- [x] 1.4 GREEN: Insert selected command name, handle cancel (keep `/` prefix)

## 2. File completion (@) added

- [ ] 2.1 Add logic to detect `@` at line start
- [ ] 2.2 Get list of files in current directory for completion
- [ ] 2.3 Call vim.ui.select() with file list
- [ ] 2.4 Insert selected file with `@` prefix

## 3. Validation

- [x] 3.1 Run `make validate` and fix any issues
- [x] 3.2 Test manually: type `/` in prompt, verify picker appears