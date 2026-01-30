# GraphQL Client

Execute GraphQL queries from `.graphql` files with support for headers, variables, and custom endpoints.

## Commands

### query_file

Execute a GraphQL query from a file.

```bash
mj graphql query_file <file.graphql>
```

**Output:** JSON response from the GraphQL API

**Examples:**

Execute a query and pretty-print the response:
```bash
mj graphql query_file GetUser.graphql | jq
```

Extract specific fields from the response:
```bash
mj graphql query_file GetUser.graphql | jq '.data.user.name'
```

Save response to a file:
```bash
mj graphql query_file GetUser.graphql > response.json
```

## GraphQL File Format

GraphQL files can include configuration comments at the top of the file:

```graphql
# gql-endpoint: http://api.example.com/graphql
# gql-header: Authorization: Bearer YOUR_TOKEN_HERE
# gql-header: Content-Type: application/json
# gql-variables: { "input": { "id": "123" } }

query GetUser($input: UserInput!) {
  user(input: $input) {
    id
    name
    email
  }
}
```

### Configuration Comments

- `# gql-endpoint:` - The GraphQL API endpoint URL (required)
- `# gql-header:` - HTTP headers (can be specified multiple times)
- `# gql-variables:` - JSON variables for the query

## Complete Examples

### Example 1: Simple Query

**File:** `GetUsers.graphql`
```graphql
# gql-endpoint: https://api.example.com/graphql
# gql-header: Authorization: Bearer abc123def456
# gql-header: Content-Type: application/json

query GetUsers {
  users {
    id
    name
    email
  }
}
```

**Execute:**
```bash
mj graphql query_file GetUsers.graphql | jq
```

**Response:**
```json
{
  "data": {
    "users": [
      {
        "id": "1",
        "name": "John Doe",
        "email": "john@example.com"
      },
      {
        "id": "2",
        "name": "Jane Smith",
        "email": "jane@example.com"
      }
    ]
  }
}
```

### Example 2: Query with Variables

**File:** `GetUser.graphql`
```graphql
# gql-endpoint: https://api.example.com/graphql
# gql-header: Authorization: Bearer abc123def456
# gql-header: Content-Type: application/json
# gql-variables: { "id": "1" }

query GetUser($id: ID!) {
  user(id: $id) {
    id
    name
    email
    posts {
      id
      title
    }
  }
}
```

**Execute:**
```bash
mj graphql query_file GetUser.graphql | jq '.data.user'
```

**Response:**
```json
{
  "id": "1",
  "name": "John Doe",
  "email": "john@example.com",
  "posts": [
    {
      "id": "101",
      "title": "My First Post"
    }
  ]
}
```

### Example 3: Mutation

**File:** `CreateUser.graphql`
```graphql
# gql-endpoint: https://api.example.com/graphql
# gql-header: Authorization: Bearer abc123def456
# gql-header: Content-Type: application/json
# gql-variables: { "input": { "name": "Bob Johnson", "email": "bob@example.com" } }

mutation CreateUser($input: CreateUserInput!) {
  createUser(input: $input) {
    user {
      id
      name
      email
    }
    errors {
      path
      message
    }
  }
}
```

**Execute:**
```bash
mj graphql query_file CreateUser.graphql | jq
```

**Response:**
```json
{
  "data": {
    "createUser": {
      "user": {
        "id": "3",
        "name": "Bob Johnson",
        "email": "bob@example.com"
      },
      "errors": []
    }
  }
}
```

### Example 4: Complex Variables

**File:** `SearchPosts.graphql`
```graphql
# gql-endpoint: https://api.example.com/graphql
# gql-header: Authorization: Bearer abc123def456
# gql-variables: { "filter": { "status": "published", "tags": ["tech", "ruby"] }, "limit": 10 }

query SearchPosts($filter: PostFilter!, $limit: Int) {
  posts(filter: $filter, limit: $limit) {
    edges {
      node {
        id
        title
        author {
          name
        }
        tags
      }
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

**Execute:**
```bash
mj graphql query_file SearchPosts.graphql | jq '.data.posts.edges[].node'
```

## Using with jq

The `jq` tool is excellent for processing JSON responses:

### Extract specific fields:
```bash
mj graphql query_file GetUser.graphql | jq '.data.user.name'
# "John Doe"
```

### Get array of values:
```bash
mj graphql query_file GetUsers.graphql | jq '.data.users[].email'
# "john@example.com"
# "jane@example.com"
```

### Filter results:
```bash
mj graphql query_file GetUsers.graphql | jq '.data.users[] | select(.name == "John Doe")'
```

### Format output:
```bash
mj graphql query_file GetUsers.graphql | jq -r '.data.users[] | "\(.name) <\(.email)>"'
# John Doe <john@example.com>
# Jane Smith <jane@example.com>
```

## Environment Variables

Instead of hardcoding tokens in files, use environment variables:

```graphql
# Use ${TOKEN} placeholder in your scripts
# gql-header: Authorization: Bearer ${TOKEN}
```

Then execute with:
```bash
TOKEN=abc123def456 mj graphql query_file GetUser.graphql
```

Or set in your shell profile:
```bash
export GRAPHQL_TOKEN=abc123def456
```

## Use Cases

1. **API Testing** - Test GraphQL APIs without writing code
2. **Data Migration** - Extract data from GraphQL APIs
3. **CI/CD Integration** - Run queries as part of automated workflows
4. **Documentation** - Keep example queries in version control
5. **Development** - Quickly test queries during development
6. **Scripting** - Use with shell scripts and jq for automation

## Tips

- Keep authentication tokens in environment variables or secure vaults
- Use `.graphql` extension for syntax highlighting in editors
- Combine with `jq` for powerful JSON processing
- Store common queries in a dedicated directory for reuse
- Use descriptive filenames that indicate the query purpose
- Add comments in GraphQL files to document query usage
