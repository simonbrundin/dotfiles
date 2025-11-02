# Elephant Integration

## MODIFIED Requirements

#### Scenario: Elephant service running
Given Elephant backend is required
When Walker starts
Then Elephant service is active and responding

#### Scenario: All providers loaded
Given multiple providers configured
When Elephant initializes
Then websearch and other providers are loaded successfully

#### Scenario: Websearch entries visible
Given websearch provider active
When Walker opens with empty query
Then custom websearch entries are displayed