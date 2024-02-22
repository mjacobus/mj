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

    $ bundle install

Or install it yourself as:

    $ gem install mj

## Usage

```bash
mj help
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
# gql-header: Cookie: ajs_user_id=ae3948ee-345e-47f2-8e2f-54277858e2c2; ajs_anonymous_id=30880a34-276e-4a86-a1d3-8869d1669199; _ga=GA1.1.649149230.1706868690; browser_id=14af87a406ec54cbe9804ea25c8f0a84; _ga_TZKSP5TS45=GS1.1.1708606615.26.1.1708606911.0.0.0
# gql-variables: { "input": { "id": "yTXuIgoU88LKUNDLSVPFFjOSkgxlyyuSrNki3GY=" } }

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

Bug reports and pull requests are welcome on GitHub at https://github.com/mjacobus/mj. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mjacobus/mj/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mj project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mjacobus/mj/blob/main/CODE_OF_CONDUCT.md).
