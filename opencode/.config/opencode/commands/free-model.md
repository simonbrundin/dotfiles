---
description: Check free AI models from OpenRouter and recommend top 3 for coding and infrastructure
agent: build
---

Check free AI models from OpenRouter and recommend top 3 for coding and infrastructure work.

## Step 1: Fetch Free Models from OpenRouter API

Use curl to fetch model data from OpenRouter API and filter for free models:

```bash
curl -s "https://openrouter.ai/api/v1/models" | jq -r '.data[] | select(.pricing.prompt == "0" or .pricing.completion == "0") | "\(.id) - \(.name) - Context: \(.context_length)"' | sort -t: -k3 -nr
```

## Step 2: Filter for Models Suitable for Coding and Infrastructure

Focus on models that excel at:

- Code generation and completion
- Infrastructure as code (IaC)
- Debugging and troubleshooting
- System administration
- Cloud and DevOps tasks

### Key Criteria for Selection:

- Large context windows (100k+ tokens preferred)
- Strong reasoning capabilities
- Good performance for technical tasks
- Active provider status
- Proven track record for coding work

## Step 3: Identify Top 3 Recommendations

Based on analysis of free models, the top recommendations for coding and infrastructure are:

### 1. **Qwen: Qwen3 Coder 480B A35B** (qwen/qwen3-coder:free)

- **Context:** 262,000 tokens
- **Provider:** Qwen (Alibaba)
- **Best for:** Large-scale code generation, complex infrastructure as code
- **Strengths:** Massive context window, specialized for coding tasks, handles large codebases well

### 2. **StepFun: Step 3.5 Flash** (stepfun/step-3.5-flash:free)

- **Context:** 256,000 tokens
- **Provider:** StepFun
- **Best for:** General coding, debugging, infrastructure automation
- **Strengths:** Sparse MoE architecture for efficiency, excellent reasoning capabilities

### 3. **NVIDIA: Nemotron 3 Nano 30B A3B** (nvidia/nemotron-3-nano-30b-a3b:free)

- **Context:** 256,000 tokens
- **Provider:** NVIDIA
- **Best for:** System-level programming, infrastructure management
- **Strengths:** Optimized for agentic systems, open weights for customization

## Step 4: Present Recommendations to User

Use the **question** tool to present the top 3 models:

```
Top 3 Free Models for Coding & Infrastructure:

1. **Qwen: Qwen3 Coder 480B A35B**
   - Context: 262K tokens
   - Best for: Large-scale code generation, complex infrastructure as code
   - Provider: Qwen (Alibaba)

2. **StepFun: Step 3.5 Flash**
   - Context: 256K tokens
   - Best for: General coding, debugging, infrastructure automation
   - Provider: StepFun

3. **NVIDIA: Nemotron 3 Nano 30B A3B**
   - Context: 256K tokens
   - Best for: System-level programming, infrastructure management
   - Provider: NVIDIA

Which model would you like to use?
```

## Step 5: Additional Information

### Other Notable Free Models:

- **Free Models Router** (openrouter/free): Router that selects from available free models
- **Arcee: Trinity Large Preview** (131K context): Good for complex reasoning tasks
- **OpenAI: gpt-oss-120b** (131K context): Open-source variant from OpenAI

### Provider Status Notes:

- All listed models currently have active providers
- Models with larger context windows are generally better for infrastructure work
- Specialized coder models perform better for specific programming tasks

### Usage Considerations:

- Free models may have rate limits
- Performance varies by task type
- Always test with specific use cases
- Monitor for provider availability changes

