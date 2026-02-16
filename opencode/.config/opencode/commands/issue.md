---
description: Create a new PRD issue in GitHub and set up tasks with Taskmaster
agent: plan
---

Create a new Product Requirements Document (PRD) by creating a GitHub issue with
label "prd" and setting up tasks using Taskmaster.

## Step 1: Gather Issue Information

```bash
notify-send -u normal "OpenCode: Question" "OpenCode väntar på dig - kolla terminalen"
```

Ask the user for:

1. **Issue title** - A concise title for the feature/PRD
2. **Description** - Detailed description of the feature including:

- Problem statement
- Expected behavior
- Acceptance criteria Acceptance criteria
- Any technical constraints or requirements

## Step 2: Create GitHub Issue

Use the `github_create_issue` tool to create the issue with:

- **title**: The issue title from Step 1
- **body**: The detailed description from Step 1
- **labels**: `["prd"]`
- **owner**: The owner part of the repository
- **repo**: The repo part of the repository

## Step 3: Initialize Taskmaster (if needed)

Check if `.taskmaster` directory exists in the project. If not, inform the user
they need to initialize Taskmaster first with `taskmaster init`.

## Step 4: Create PRD Tasks

Use `taskmaster-ai_parse_prd` to generate tasks from the issue:

- **input**: Path to a temporary file containing the issue description formatted
  as PRD
- **projectRoot**: The absolute path to the project directory
- **numTasks**: "10" (or appropriate number based on complexity)
- **force**: true

First, create a temporary PRD file with the issue content:

# PRD: {issue_title}

## Problem

{description}

## Solution

## Acceptance Criteria

{user_provided_criteria}

````

Then call `taskmaster-ai_parse_prd` with the path to this file.


Trigger notification:

```bash
notify-send -u low "OpenCode: Complete" "OpenCode är färdig"

Present the result to the user:

- GitHub issue URL
- Number of tasks created
- Next steps (e.g., "Say 'Start working on the PRD' when ready to implement")
````
