# pre-commit-msg

commit-msg hook to validate commit message, These hooks are made as custom plugins under the [pre-commit](http://pre-commit.com/#new-hooks) git hook framework.

# Setup

Just add to your `.pre-commit-config.yaml` file with the following

```yaml
- repo: git@github.com:charleslxh/pre-commit-msg.git
  sha: 1.0.0
  hooks:
  - id: check-commit-msg
    args: [--min-length=10 --max-length=100]
```
