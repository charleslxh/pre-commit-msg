# pre-commit-msg

[![Build Status](https://travis-ci.org/charleslxh/pre-commit-msg.svg?branch=master)](https://travis-ci.org/charleslxh/pre-commit-msg)

commit-msg hook to validate commit message, These hooks are made as custom plugins under the [pre-commit](http://pre-commit.com/#new-hooks) git hook framework.

# Setup

Just add to your `.pre-commit-config.yaml` file with the following

```yaml
- repo: git@github.com:charleslxh/pre-commit-msg.git
  sha: 1.0.0
  hooks:
  - id: check-commit-msg
    args: [-g 10 -l 100]
```

Auguments:

1. `-g`: sprcify the min length of commit message, default: *10*.
2. `-l`: sprcify the max length of commit message, default: *100*.
