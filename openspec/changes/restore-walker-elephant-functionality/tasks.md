# Ordered Tasks for Restoring Walker and Elephant Functionality

1. **Validate Walker config syntax** - Check `walker/.config/walker/config.toml` for TOML syntax errors and missing required sections
2. **Add missing provider actions** - Ensure all providers have proper action definitions, especially desktopapplications for launching apps
3. **Add missing provider prefixes** - Include all standard prefixes from default config to enable prefixed searches
4. **Test Walker basic functionality** - Launch Walker and verify applications can be launched with Enter
5. **Verify Elephant service status** - Ensure Elephant daemon is running and all providers are loaded
6. **Test websearch integration** - Confirm websearch entries appear in empty state and searches work with @ prefix
7. **Validate end-to-end functionality** - Perform comprehensive test of search, launch, and websearch features