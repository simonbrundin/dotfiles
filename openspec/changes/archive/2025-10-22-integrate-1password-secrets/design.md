## Context
The current dotfiles setup stores sensitive information like API keys and tokens in plain text within configuration files. This poses security risks, especially in a version-controlled repository. Chezmoi supports external secrets managers, and 1Password provides a secure, user-friendly option for secret storage and retrieval.

## Goals / Non-Goals
- Goals: Enable secure storage of secrets in 1Password, integrate with chezmoi templating, maintain cross-machine consistency
- Non-Goals: Replace all configuration management, handle secrets for non-dotfile use cases, implement custom secret encryption

## Decisions
- Decision: Use 1Password CLI (op) as the secrets backend for chezmoi
- Alternatives considered: HashiCorp Vault (too heavy for personal use), AWS Secrets Manager (cloud-dependent), local encryption (less user-friendly)
- Decision: Store secrets in dedicated 1Password vault items with structured fields
- Decision: Use chezmoi's built-in secret templating syntax

## Risks / Trade-offs
- Dependency on 1Password subscription and CLI availability
- Authentication complexity on new machines vs improved security
- Potential performance impact from CLI calls during chezmoi apply

## Migration Plan
1. Install and configure 1Password CLI
2. Create vault items for existing secrets
3. Update dotfiles to use secret templates
4. Test on development machine
5. Deploy to production machines with authentication setup

## Open Questions
- How to handle secrets that need different values per machine?
- Should we create a dedicated vault for dotfiles secrets?</content>
</xai:function_call ><xai:function_call name="bash">
<parameter name="command">openspec validate integrate-1password-secrets --strict