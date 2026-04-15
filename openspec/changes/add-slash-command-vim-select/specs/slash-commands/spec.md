## ADDED Requirements
### Requirement: Slash Command Selection
The plugin SHALL allow users to select slash commands from a list when typing `/` at the start of the prompt.

#### Scenario: Select command from list
- **WHEN** user types `/` at the start of the prompt line
- **THEN** a selection list appears showing available commands with descriptions

#### Scenario: Command selection completes
- **WHEN** user selects a command from the list and confirms
- **THEN** the selected command appears with the `/` prefix in the prompt input (e.g., `/commit`)

#### Scenario: Selection cancelled
- **WHEN** user cancels the selection (e.g., presses Escape)
- **THEN** the `/` prefix remains in the prompt input unchanged