# Mj

A collection of useful CLI commands for software development workflow automation.

[![Ruby](https://github.com/mjacobus/mj/actions/workflows/main.yml/badge.svg)](https://github.com/mjacobus/mj/actions/workflows/main.yml)
[![Coverage Status](https://coveralls.io/repos/github/mjacobus/mj/badge.svg?branch=main)](https://coveralls.io/github/mjacobus/mj?branch=main)
[![Maintainability](https://api.codeclimate.com/v1/badges/52468dead5a8c7568a0f/maintainability)](https://codeclimate.com/github/mjacobus/mj/maintainability)

## Features

- **Alternative File Navigation** - Quickly navigate between related files (specs, implementations, views)
- **Git Utilities** - Smart branch checkout and stale branch cleanup
- **GraphQL Client** - Execute GraphQL queries from files with headers and variables
- **ChatGPT Integration** - CLI access to ChatGPT with custom configurations

## Installation

Install the gem:

```bash
gem install mj
```

Or add to your Gemfile:

```ruby
gem 'mj'
```

## Quick Start

```bash
# Get help
mj help

# List available commands
mj help alternative_file
mj help git
mj help graphql
mj help chatgpt

# Quick examples
mj alternative_file list app/models/user.rb
mj git checkout feature-branch
mj graphql query_file query.graphql
mj chatgpt ask "What is Ruby?"
```

## Documentation

- [Alternative File Navigation](docs/alternative_file.md) - Navigate between specs, implementations, and views
- [Git Utilities](docs/git.md) - Branch management and cleanup tools
- [GraphQL Client](docs/graphql.md) - Execute GraphQL queries from files
- [ChatGPT Integration](docs/chatgpt.md) - CLI access to ChatGPT

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/mjacobus/mj>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mjacobus/mj/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mj project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mjacobus/mj/blob/main/CODE_OF_CONDUCT.md).
