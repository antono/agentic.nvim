## ADDED Requirements
### Requirement: Slash Command Selection
The plugin SHALL allow users to select slash commands from a list when typing `/` at the start of the prompt.

#### Scenario: Select command from list
- **WHEN** user types `/` at the start of the prompt line
- **THEN** a selection list appears showing available commands with descriptions

#### Scenario: Command selection completes
- **WHEN** user selects a command from the list and confirms
- **THEN** the selected command appears with the `/` prefix in the prompt input (e.g., `/commit`)
- **AND** the cursor is positioned at the end of the completed command
- **AND** Neovim is in insert mode (ready for typing)

#### Scenario: Selection cancelled
- **WHEN** user cancels the selection (e.g., presses Escape)
- **THEN** the `/` prefix remains in the prompt input unchanged
- **AND** Neovim remains in insert mode

### Requirement: File Reference Completion
The plugin SHALL allow users to select files from a list when typing `@` at the start of the prompt.

#### Scenario: Select file from list
- **WHEN** user types `@` anywhere in the prompt line
- **THEN** a selection list appears showing files in the current directory

#### Scenario: File selection completes
- **WHEN** user selects a file from the list and confirms
- **THEN** the selected filename appears with the `@` prefix in the prompt input (e.g., `@filename`)
- **AND** the cursor is positioned at the end of the filename
- **AND** Neovim is in insert mode (ready for typing)

#### Scenario: File selection cancelled
- **WHEN** user cancels the selection (e.g., presses Escape)
- **THEN** the `@` prefix remains in the prompt input unchanged
- **AND** Neovim remains in insert mode