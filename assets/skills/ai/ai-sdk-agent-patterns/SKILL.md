---
provenance:
  source: AI SDK
  source_url: https://github.com/vercel/ai
  license: Apache-2.0
  verified: 2026-11-23
maturity: beta
name: ai-sdk-agent-patterns
description: Build provider-agnostic agents with schema-validated outputs, typed tool contracts, step budgets, streaming and deliberate prompt-injection boundaries.
category: ai
version: 0.1.0
author: devtiagoabreu
tags: [llm, agents, tools, structured-output, streaming, providers]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - a TypeScript runtime with a supported model provider
provides:
  - A tool contract template
  - Step and concurrency budgets for agent loops
  - An injection-boundary checklist for model inputs
security:
  risk_level: medium
  permissions:
    - network
  audited: true
difficulty: intermediate
---

# AI SDK Agent Patterns

## Overview

A good agent layer separates four things: the provider, the output contract, the tools and the loop budget. Keeping them separate lets you swap models without rewriting business logic and lets you test each boundary independently.

## Prerequisites

- A provider connection and model identifier.
- A schema library such as Zod for inputs and outputs.
- Defined limits for steps, tokens and tool concurrency.

## Usage Instructions

### 1. Use one provider-agnostic call surface

```ts
const { text } = await generateText({
  model: "anthropic/claude-sonnet-5.5",
  prompt: "Summarize the release notes."
});
```

Switching providers should be a model string or adapter change. Keep provider-specific features behind a small wrapper so they do not spread through the app.

### 2. Make output a contract, not a hope

```ts
const { output } = await generateText({
  model,
  output: Output.object({ schema: TicketSchema }),
  prompt
});
```

Validate at the boundary. Treat a failed parse as a retryable failure with a bounded attempt count, not as permission to accept partial data.

### 3. Define tools with three explicit parts

| Part | Purpose |
|---|---|
| `description` | Tells the model when the tool is relevant |
| `inputSchema` | Validates the model's arguments before execution |
| `execute` | Performs the action and returns a compact result |

Return short, structured results. Large payloads belong behind a second retrieval step with its own budget.

### 4. Bound the loop

```ts
const agent = new ToolLoopAgent({
  model,
  instructions: systemRules,
  tools: { search: searchTool },
  stopWhen: stepCountIs(10)
});
```

Set step limits, token limits and `toolCallConcurrency`. Use `1` when tools mutate shared state. Emit `onStepFinish` and `onStepError` events into your trace store so a run can be replayed.

### 5. Keep untrusted text out of instructions

Provider messages supplied by users can contain instruction-like text. Do not enable system messages inside user-provided `messages`, and do not concatenate fetched web content into the system prompt. Put untrusted content in a clearly labeled user or tool result, and require tools to validate intent before side effects.

### 6. Stream deliberately

Use streaming for interactive experiences and plain generation for batch work. If you need low-memory streaming, choose the variant that avoids a replay buffer and remember that tools and structured output still retain their required content.

### 7. Package tools like libraries

A tool is a plain object, so it can be published, versioned and configured with a preset. Pin tool package versions and review their permissions before adding them to an agent.

## Examples

### Example 1: Tool definition

```ts
const lookup = tool({
  description: "Find an order by its public identifier.",
  inputSchema: z.object({ orderId: z.string().regex(/^ord_[a-z0-9]+$/) }),
  execute: async ({ orderId }) => findOrder(orderId)
});
```

### Example 2: Run budget record

```yaml
maxSteps: 10
maxOutputTokens: 4000
toolCallConcurrency: 1
allowedTools: [lookup, summarize]
trace: enabled
onStepError: record-and-stop-after-2
```

## References

- [AI SDK](https://github.com/vercel/ai)
- [AI SDK tools](https://ai-sdk.dev/docs/foundations/tools)
- Kit companions: `llm-multi-provider`, `harness-engineering-patterns`
