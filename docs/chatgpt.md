# ChatGPT Integration

CLI client for OpenAI's ChatGPT API with support for custom configurations and prompts.

## Commands

### ask

Ask ChatGPT a question from the command line.

```bash
mj chatgpt ask "<question>" [options]
```

**Options:**
- `--config-file` - Path to a YAML configuration file

**Output:** JSON response from OpenAI API

**Examples:**

Ask a simple question:
```bash
mj chatgpt ask "What is Ruby?" | jq
```

Ask a question with custom configuration:
```bash
mj chatgpt ask "Who won the World Cup in 1994?" \
  --config-file config.yml | jq
```

Extract just the answer:
```bash
mj chatgpt ask "What is 2 + 2?" | jq -r '.choices[0].message.content'
# "2 + 2 equals 4."
```

## Configuration File Format

Create a YAML file to configure the ChatGPT request:

```yaml
request:
  parameters:
    model: gpt-3.5-turbo-16k
    temperature: 0.1
    messages:
    - role: system
      content: You are an expert in Ruby programming.
```

### Configuration Options

- `model` - OpenAI model to use (e.g., `gpt-3.5-turbo`, `gpt-4`, `gpt-3.5-turbo-16k`)
- `temperature` - Randomness of responses (0.0 to 2.0, lower is more focused)
- `messages` - Array of message objects with `role` and `content`

### Message Roles

- `system` - Sets the behavior/context for the assistant
- `user` - User messages (questions)
- `assistant` - Previous assistant responses (for conversation context)

## Complete Examples

### Example 1: Simple Question

```bash
mj chatgpt ask "Explain what a Ruby gem is" | jq -r '.choices[0].message.content'
```

**Response:**
```
A Ruby gem is a package or library that contains reusable Ruby code. Gems are distributed through RubyGems, the Ruby community's package manager. They allow developers to easily share and use functionality created by others, making it simple to add features to Ruby applications without writing everything from scratch.
```

### Example 2: Technical Expert

**File:** `config/ruby-expert.yml`
```yaml
request:
  parameters:
    model: gpt-4
    temperature: 0.1
    messages:
    - role: system
      content: |
        You are an expert Ruby developer with deep knowledge of:
        - Ruby language features and idioms
        - Rails framework and best practices
        - Testing with RSpec
        - Code design and architecture

        Provide concise, accurate answers with code examples when appropriate.
```

**Execute:**
```bash
mj chatgpt ask "How do I use Ruby's reduce method?" \
  --config-file config/ruby-expert.yml | jq -r '.choices[0].message.content'
```

### Example 3: Code Review Assistant

**File:** `config/code-reviewer.yml`
```yaml
request:
  parameters:
    model: gpt-4
    temperature: 0.2
    messages:
    - role: system
      content: |
        You are a senior code reviewer. When reviewing code:
        - Identify potential bugs and edge cases
        - Suggest improvements for readability and maintainability
        - Check for security vulnerabilities
        - Recommend better design patterns when applicable
        - Be constructive and specific in your feedback
```

**Execute:**
```bash
mj chatgpt ask "Review this code: def process(data); data.map(&:upcase); end" \
  --config-file config/code-reviewer.yml | jq -r '.choices[0].message.content'
```

### Example 4: Football History Expert

**File:** `config/football-expert.yml`
```yaml
request:
  parameters:
    model: gpt-3.5-turbo-16k
    temperature: 0.1
    messages:
    - role: system
      content: You are an expert in football history with detailed knowledge of World Cup tournaments, players, and memorable matches.
```

**Execute:**
```bash
mj chatgpt ask "Who won the World Cup in 1994?" \
  --config-file config/football-expert.yml | jq
```

**Response:**
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

## Response Format

The JSON response includes:

- `id` - Unique identifier for the completion
- `choices` - Array of response choices (usually just one)
  - `message.content` - The actual response text
  - `message.role` - Always "assistant"
  - `finish_reason` - Why the response ended (usually "stop")
- `usage` - Token usage information
  - `prompt_tokens` - Tokens in your question
  - `completion_tokens` - Tokens in the response
  - `total_tokens` - Total tokens used

## Using with jq

Process responses with `jq`:

### Get just the answer:
```bash
mj chatgpt ask "What is Ruby?" | jq -r '.choices[0].message.content'
```

### Get token usage:
```bash
mj chatgpt ask "What is Ruby?" | jq '.usage'
```

### Check the model used:
```bash
mj chatgpt ask "What is Ruby?" | jq -r '.model'
```

### Get multiple fields:
```bash
mj chatgpt ask "What is Ruby?" | jq '{answer: .choices[0].message.content, tokens: .usage.total_tokens}'
```

## Setup

### Environment Variables

Set your OpenAI API token:

```bash
export OPENAI_ACCESS_TOKEN=sk-...your-token...
```

Add to your shell profile (~/.bashrc, ~/.zshrc):
```bash
echo 'export OPENAI_ACCESS_TOKEN=sk-...your-token...' >> ~/.zshrc
```

### Getting an API Key

1. Sign up at [OpenAI](https://platform.openai.com/)
2. Navigate to API Keys section
3. Create a new API key
4. Copy and save it securely
5. Set the `OPENAI_ACCESS_TOKEN` environment variable

## Use Cases

1. **Quick Answers** - Get programming answers without opening a browser
2. **Code Assistance** - Ask about syntax, patterns, and best practices
3. **Automated Tasks** - Integrate into scripts for text generation
4. **Documentation** - Generate explanations or documentation
5. **Learning** - Create custom tutors with specialized system prompts
6. **Code Review** - Get automated code review suggestions
7. **Translation** - Translate code or text between languages

## Tips

- Keep your API key secure and never commit it to version control
- Use lower temperature (0.1-0.3) for factual, consistent responses
- Use higher temperature (0.7-1.0) for creative tasks
- Create reusable config files for different personas/contexts
- Combine with shell scripts for automation
- Use `gpt-3.5-turbo` for faster, cheaper responses
- Use `gpt-4` for more complex reasoning tasks
- Monitor your token usage to control costs
- Use system messages to set consistent behavior

## Cost Optimization

- Start with `gpt-3.5-turbo` (cheaper) before using `gpt-4`
- Keep questions concise to reduce token usage
- Use lower `temperature` for more deterministic (cheaper) results
- Monitor usage with `jq '.usage.total_tokens'`
- Set appropriate `max_tokens` in config to limit response length

## Common Config Templates

### Quick Facts (Cheap & Fast)
```yaml
request:
  parameters:
    model: gpt-3.5-turbo
    temperature: 0.1
    max_tokens: 150
```

### Code Assistant (Balanced)
```yaml
request:
  parameters:
    model: gpt-3.5-turbo-16k
    temperature: 0.3
```

### Complex Reasoning (Powerful)
```yaml
request:
  parameters:
    model: gpt-4
    temperature: 0.2
```

### Creative Writing (Open-ended)
```yaml
request:
  parameters:
    model: gpt-4
    temperature: 0.9
```
