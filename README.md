# pre-commit-msg

commit-msg hook for pre-commit

# Setup

Just add to your `.pre-commit-config.yaml` file with the following

```yaml
- repo: git@github.com:charleslxh/pre-commit-msg.git
  sha: 1.0.0
  hooks:
  - id: check-commit-msg
```
