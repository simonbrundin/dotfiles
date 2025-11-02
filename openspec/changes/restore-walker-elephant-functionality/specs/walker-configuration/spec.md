# Walker Configuration

## MODIFIED Requirements

#### Scenario: Valid TOML syntax
Given Walker config file exists
When parsing the config
Then no syntax errors occur

#### Scenario: Complete provider actions
Given providers are configured
When actions are defined for each provider
Then default actions like "start" for desktopapplications are available

#### Scenario: Provider prefixes defined
Given providers require prefixes
When prefixes are configured
Then users can use @ for websearch and other prefixes for specific providers