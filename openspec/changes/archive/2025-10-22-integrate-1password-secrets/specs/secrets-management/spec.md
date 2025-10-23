## ADDED Requirements

### Requirement: 1Password Secrets Backend
Chezmoi SHALL support retrieving secrets from 1Password using the 1Password CLI as a secrets backend.

#### Scenario: Secret Retrieval Success
- **WHEN** chezmoi encounters a secret template referencing a 1Password item
- **THEN** it SHALL use the 1Password CLI to retrieve the secret value
- **AND** substitute the template with the retrieved value

#### Scenario: Authentication Required
- **WHEN** 1Password CLI is not authenticated
- **THEN** chezmoi SHALL fail with a clear error message indicating authentication is needed

### Requirement: Secure Secret Storage
Sensitive configuration values SHALL be stored in 1Password vaults instead of plain text in dotfiles.

#### Scenario: API Key Migration
- **WHEN** an API key is identified in dotfiles
- **THEN** it SHALL be moved to a 1Password vault item
- **AND** the dotfile SHALL use a chezmoi secret template to retrieve it

### Requirement: Documentation for Secret Management
The project SHALL include documentation on how to set up and use 1Password integration for secrets.

#### Scenario: New Machine Setup
- **WHEN** setting up dotfiles on a new machine
- **THEN** clear instructions SHALL be available for configuring 1Password CLI authentication
- **AND** guidance on creating required vault items</content>
</xai:function_call ><xai:function_call name="bash">
<parameter name="command">openspec validate integrate-1password-secrets --strict