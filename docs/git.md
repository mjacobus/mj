# Git Utilities

Useful Git commands for branch management and cleanup.

## Commands

### checkout

Checkout a branch using partial name matching. This is useful when you have long branch names or want to quickly switch branches without typing the full name.

```bash
mj git checkout <partial-branch-name> [options]
```

**Options:**
- `--dry-run` / `-d` - Show what would be executed without checking out

**Examples:**

Checkout a branch with partial name match:
```bash
mj git checkout feature
```

This will find and checkout a branch that matches "feature", such as:
- `feature/user-authentication`
- `feature-branch`
- `user-feature`

If the branch only exists remotely, it will create a local tracking branch:
```bash
mj git checkout user-auth
```

This executes:
```bash
git checkout -b feature/user-authentication origin/feature/user-authentication
```

Preview the command without executing (dry run):
```bash
mj git checkout feature --dry-run
```

Output:
```
git checkout feature/user-authentication
```

### delete_stale_branches

Delete stale remote branches based on various criteria. This helps keep your repository clean by removing old feature branches that are no longer needed.

```bash
mj git delete_stale_branches [options]
```

**Options:**
- `--dry-run` / `-d` - Show what would be deleted without actually deleting
- `--only-with-prs` / `-p` - Only delete branches that have associated pull requests (safer, as branches can be restored from PR page)
- `--only-with-closed-prs` / `-c` - Only delete branches with closed PRs (excludes DRAFT and OPEN PRs that might still be merged)
- `--after-date` / `-a` - Only branches created after this date (format: YYYY-MM-DD)
- `--before-date` / `-b` - Only branches created before this date (format: YYYY-MM-DD)
- `--from-pull-requestors` / `-u` - Filter by GitHub username (comma-separated)
- `--from-commiters` / `-e` - Filter by committer email addresses (comma-separated, checks last committer)

**Examples:**

Preview stale branches (dry run):
```bash
mj git delete_stale_branches --dry-run
```

Delete branches that have closed pull requests:
```bash
mj git delete_stale_branches --only-with-closed-prs
```

Delete old branches created before a specific date:
```bash
mj git delete_stale_branches --before-date=2024-01-01
```

Delete branches from specific contributors:
```bash
mj git delete_stale_branches \
  --from-commiters=user@example.com,other@example.com \
  --dry-run
```

Delete branches from specific GitHub users with closed PRs:
```bash
mj git delete_stale_branches \
  --from-pull-requestors=mjacobus,contributor \
  --only-with-closed-prs
```

Safe cleanup (only branches with PRs, closed status):
```bash
mj git delete_stale_branches \
  --only-with-prs \
  --only-with-closed-prs \
  --dry-run
```

Cleanup old branches within a date range:
```bash
mj git delete_stale_branches \
  --after-date=2023-01-01 \
  --before-date=2023-12-31 \
  --only-with-closed-prs
```

## Use Cases

### Partial Branch Checkout

1. **Long Branch Names** - Quickly checkout branches without typing full names
2. **Remote-Only Branches** - Automatically create local tracking branches
3. **Team Workflows** - Quickly switch to team members' branches

### Stale Branch Deletion

1. **Repository Cleanup** - Remove old feature branches after they're merged
2. **Team Hygiene** - Keep the branch list manageable for the team
3. **Storage Management** - Reduce repository size by removing unused branches
4. **Safe Cleanup** - Use `--only-with-prs` to ensure branches can be restored

## Safety Tips

### For checkout

- Use `--dry-run` to preview which branch will be checked out
- Be aware that partial matching may select unexpected branches if multiple matches exist

### For delete_stale_branches

- **Always use `--dry-run` first** to preview what will be deleted
- Use `--only-with-prs` to ensure branches can be restored from GitHub
- Use `--only-with-closed-prs` to avoid deleting branches that might still be merged
- Combine filters to target specific branches precisely
- Be cautious with date ranges - double-check the dates
- Test on a non-critical repository first

### Recommended Safe Workflow

```bash
# Step 1: Preview with dry-run
mj git delete_stale_branches \
  --only-with-closed-prs \
  --before-date=2024-01-01 \
  --dry-run

# Step 2: Review the output carefully

# Step 3: Execute if output looks correct
mj git delete_stale_branches \
  --only-with-closed-prs \
  --before-date=2024-01-01
```

## Requirements

- Git must be installed and configured
- For PR-related options, GitHub CLI (`gh`) must be installed and authenticated
- Appropriate permissions to delete remote branches

## Environment Variables

The `delete_stale_branches` command may require GitHub authentication:

```bash
# GitHub CLI should be authenticated
gh auth login
```
