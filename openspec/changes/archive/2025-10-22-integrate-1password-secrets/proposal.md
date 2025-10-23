## Why
The current dotfiles setup lacks secure secret management, requiring manual handling of sensitive configuration values. Integrating 1Password will enable secure storage and retrieval of secrets within chezmoi-managed dotfiles, improving security and maintainability.

## What Changes
- Add 1Password CLI as a dependency
- Configure chezmoi to use 1Password as secrets backend
- Update relevant dotfiles to use 1Password-stored secrets
- Add documentation for secret management workflow

## Impact
- Affected specs: New secrets-management capability
- Affected code: chezmoi configuration, package management, and dotfiles using secrets
- **BREAKING**: Existing manual secret handling will need migration</content>
</xai:function_call ><xai:function_call name="write">
<parameter name="filePath">openspec/changes/integrate-1password-secrets/design.md