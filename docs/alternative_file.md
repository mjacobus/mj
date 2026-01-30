# Alternative File Navigation

Navigate quickly between related files in your project. This is particularly useful for Ruby/Rails projects where you need to jump between implementations, specs, views, and other related files.

## Commands

### list

List all alternative files for a given reference file.

```bash
mj alternative_file list <reference-file> [options]
```

**Options:**
- `--types` / `-t` - Filter by file types (comma-separated: spec, test, lib, app, view)
- `--exists` / `-e` - Only show files that exist on disk
- `--debug` / `-d` - Show debug information about file resolution

**Examples:**

List all possible alternative files:
```bash
mj alternative_file list app/models/user.rb
```

Output:
```
app/models/user.rb
lib/models/user.rb
spec/models/user_spec.rb
test/models/user_test.rb
```

List only existing files:
```bash
mj alternative_file list app/models/user.rb --exists
```

Output:
```
app/models/user.rb
spec/models/user_spec.rb
```

Filter by type (show only spec files):
```bash
mj alternative_file list app/models/user.rb --types=spec
```

Output:
```
spec/models/user_spec.rb
```

### next

Get the next alternative file in the sequence.

```bash
mj alternative_file next <reference-file> [options]
```

**Options:**
- `--types` / `-t` - Filter by file types
- `--exists` / `-e` - Only consider files that exist
- `--debug` / `-d` - Show debug information

**Examples:**

Get the next alternative file:
```bash
mj alternative_file next app/models/user.rb
```

Output:
```
spec/models/user_spec.rb
```

Get the next existing file:
```bash
mj alternative_file next app/models/user.rb --exists
```

### prev

Get the previous alternative file in the sequence.

```bash
mj alternative_file prev <reference-file> [options]
```

**Options:**
- `--types` / `-t` - Filter by file types
- `--exists` / `-e` - Only consider files that exist
- `--debug` / `-d` - Show debug information

**Examples:**

Get the previous alternative file:
```bash
mj alternative_file prev spec/models/user_spec.rb
```

Output:
```
app/models/user.rb
```

## Supported File Types

The alternative file resolver supports various Ruby/Rails patterns:

### Rails Standard Structure
- `app/**/*.rb` ↔ `spec/**/*_spec.rb` ↔ `test/**/*_test.rb`
- `lib/**/*.rb` ↔ `spec/**/*_spec.rb`

### Rails Controllers
- `app/controllers/users_controller.rb` ↔ `spec/requests/users_spec.rb`
- `app/controllers/api/v1/users_controller.rb` ↔ `spec/requests/api/v1/users_spec.rb`

### Rails Subfolders (Services, Commands, etc.)
- `app/services/user_creator.rb` ↔ `spec/services/user_creator_spec.rb`
- `app/commands/create_user.rb` ↔ `spec/commands/create_user_spec.rb`

### View Components
- `app/components/button_component.rb` ↔ `app/components/button_component.html.erb` ↔ `spec/components/button_component_spec.rb`

### Packwerk (Modular Rails)
- `packs/users/app/models/user.rb` ↔ `packs/users/spec/models/user_spec.rb`

### Vendored Gems
- `vendor/gems/my_gem/lib/my_gem.rb` ↔ `vendor/gems/my_gem/spec/my_gem_spec.rb`

## IDE Integration

The alternative file commands are designed to integrate with your text editor or IDE. This allows you to quickly jump between related files with keyboard shortcuts.

### Neovim Example

```lua
-- Navigate to next alternative file with <leader>ak
vim.keymap.set('n', '<leader>ak', function()
  local file = vim.fn.expand('%')
  local cmd = 'mj alternative_file next ' .. file .. ' --exists'
  local next_file = vim.fn.system(cmd):gsub('%s+', '')

  if next_file ~= '' then
    vim.cmd('edit ' .. next_file)
  end
end, { desc = 'Next alternative file' })

-- Navigate to previous alternative file with <leader>aj
vim.keymap.set('n', '<leader>aj', function()
  local file = vim.fn.expand('%')
  local cmd = 'mj alternative_file prev ' .. file .. ' --exists'
  local prev_file = vim.fn.system(cmd):gsub('%s+', '')

  if prev_file ~= '' then
    vim.cmd('edit ' .. prev_file)
  end
end, { desc = 'Previous alternative file' })
```

### VSCode Example

Add to your `tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Next Alternative File",
      "type": "shell",
      "command": "mj alternative_file next ${file} --exists",
      "problemMatcher": []
    }
  ]
}
```

### Vim Example

```vim
" Navigate to next alternative file
nnoremap <leader>ak :execute 'edit ' . system('mj alternative_file next ' . expand('%') . ' --exists')<CR>

" Navigate to previous alternative file
nnoremap <leader>aj :execute 'edit ' . system('mj alternative_file prev ' . expand('%') . ' --exists')<CR>
```

## Use Cases

1. **Spec-Driven Development** - Quickly jump between test and implementation
2. **View Component Development** - Navigate between component Ruby, ERB, and spec files
3. **Controller/Request Spec Navigation** - Jump from controller to request specs
4. **Packwerk Projects** - Navigate within modular Rails applications
5. **Code Review** - Quickly check related files when reviewing changes

## Tips

- Use `--exists` flag when navigating to avoid jumping to non-existent files
- Combine with editor keybindings for maximum productivity
- Use `--types` to filter specific file categories when you have many alternatives
- The `--debug` flag can help understand how files are being resolved
