# Mj

A collection of useful commands for my personal use.

[![Ruby](https://github.com/mjacobus/mj/actions/workflows/main.yml/badge.svg)](https://github.com/mjacobus/mj/actions/workflows/main.yml)
[![Coverage Status](https://coveralls.io/repos/github/mjacobus/mj/badge.svg?branch=main)](https://coveralls.io/github/mjacobus/mj?branch=main)
[![Maintainability](https://api.codeclimate.com/v1/badges/52468dead5a8c7568a0f/maintainability)](https://codeclimate.com/github/mjacobus/mj/maintainability)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mj'
```

And then execute:

    bundle install

Or install it yourself as:

    gem install mj

## Usage

```bash
mj help
```

### Git

```
bundle exec mj git checkout partial-branch-name           # it will create a local branch if that is remote only
bundle exec mj git checkout partial-branch-name --dry-run # if you want to see the command before executing
```

```

### ChatGPT

```

bundle exec mj chatgpt ask "Who won the World Cup in 1994?" --request-file samples/chatgpt/football-team.yml | jq

```

Where the config file looks like:

```yaml
request:
  parameters:
    model: gpt-3.5-turbo-16k
    temperature: 0.1
    messages:
    - role: system
      content: You re an expert in futebool history.
```

Response:

```json
{
  "id": "chatcmpl-90a0HhlOIqYkMPRbuICPy5m798yjQ",
  "object": "chat.completion",
  "created": 1709925425,
  "model": "gpt-3.5-turbo-16k-0613",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "The World Cup in 1994 was won by the Brazilian national team. They defeated Italy in the final match, which was held at the Rose Bowl stadium in Pasadena, California, United States. The match ended in a 0-0 draw after extra time, and Brazil won the penalty shootout 3-2 to claim their fourth World Cup title."
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 31,
    "completion_tokens": 71,
    "total_tokens": 102
  },
  "system_fingerprint": null
}
```

You can also do `jq '.choices[0].message.content'`:

```sh
mj chatgpt ask "Who won the World Cup in 1994?" \
  --config-file samples/chatgpt/football-team.yml | jq '.choices[0].message.content'

# "The World Cup in 1994 was won by the Brazilian national team. They defeated Italy in the final match, which was held at the Rose Bowl stadium in Pasadena, California, United States. The match ended in a 0-0 draw after extra time, and Brazil won the penalty shootout 3-2 to claim their fourth World Cup title."
```

### GraphQl

```
bundle exec mj graphql query_file AccountUsers.graphql | jq
```

Your graqphql fiel is a regular file with variables at the top:

```graphql
# gql-endpoint: http://api.myapi.me/graphql
# gql-header: Authorization: Bearer cb923f33617877578961a19cf4566ec2
# gql-header: Content-Type: application/json
# gql-variables: { "input": { "id": "some-id" } }

query QueryAccountUsers(
  $input: AccountInput!
) {
  account(input: $input) {
    users {
      id
      name
    }
    errors {
      path
      message
    }
  }
}
```

### Alternative file

Examples:

```
$ mj alternative_file list app/components/attribute_component.rb
app/components/attribute_component.html.erb
app/components/attribute_component.rb
lib/components/attribute_component.rb
spec/components/attribute_component_spec.rb
test/components/attribute_component_test.rb

$ mj alternative_file list app/components/attribute_component.rb  --exists
app/components/attribute_component.html.erb
app/components/attribute_component.rb
spec/components/attribute_component_spec.rb

$ mj alternative_file list app/components/attribute_component.rb  --types=spec
spec/components/attribute_component_spec.rb

$ mj alternative_file next app/components/attribute_component.rb
lib/components/attribute_component.rb

$ mj alternative_file prev app/components/attribute_component.rb
app/components/attribute_component.html.erb
```

Why? Because you can integrate that command with your IDE/Text Editor. For instance, here's my [neovim integration](https://github.com/mjacobus/dotfiles/blob/d8ceda659dc9b587ab22b05fc15eac2fa5b477d7/neovim/.config/nvim/init.lua#L31-L63):

```lua
vimp.nnoremap('<leader>ak', function()
  open_mj_alternative_file('next', '--exists')
end)

vimp.nnoremap('<leader>aj', function()
  open_mj_alternative_file('prev', '--exists')
end)

function open_mj_alternative_file(subcommand, options)
  file_path = vim.fn.expand('%')
  files = mj_alternative_file(file_path, subcommand, options)
  files = vim.split(files, ' ')
  file = files[1]


  if file ~= '' then
    vim.api.nvim_command('e ' .. file)
  end
end

function mj_alternative_file(file, subcommand, options)
  local cmd = 'mj alternative_file ' .. subcommand .. ' ' .. file .. ' ' .. options
  return execute_command(cmd)
end

function execute_command(cmd)
  print("cmd: " .. cmd)
  local f = io.popen(cmd)
  local s = f:read('*a')
  f:close()
  return s
end
```

This way I can use `<leader>a{direction}`, where `k` is `next`, and `j` is `previous` alternative file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/mjacobus/mj>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mjacobus/mj/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mj project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mjacobus/mj/blob/main/CODE_OF_CONDUCT.md).
