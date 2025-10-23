## 1. Setup and Dependencies
- [x] 1.1 Install 1Password CLI (op) via Homebrew
- [x] 1.2 Configure 1Password CLI authentication
- [x] 1.3 Update .chezmoidata/packages.yaml to include 1Password CLI

## 2. Chezmoi Configuration
- [x] 2.1 Configure chezmoi to use 1Password as secrets backend in .chezmoi.toml.tmpl
- [x] 2.2 Test chezmoi secret command integration

## 3. Migrate Existing Secrets
- [x] 3.1 Identify sensitive values in current dotfiles (API keys, tokens, etc.)
- [x] 3.2 Create 1Password vault items for secrets
- [x] 3.3 Update dotfiles to use chezmoi secret templating

## 4. Documentation and Validation
- [x] 4.1 Update openspec/project.md with 1Password dependency
- [x] 4.2 Add comments in dotfiles explaining secret usage
- [x] 4.3 Test secret retrieval on target machines
- [x] 4.4 Document setup process for new machines</content>
</xai:function_call ><xai:function_call name="write">
<parameter name="filePath">openspec/changes/integrate-1password-secrets/specs/secrets-management/spec.md