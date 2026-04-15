# commit-standards/examples.md

## Good Examples

```
DEF0799890: modify schedule reusability logic

- Changed reusability filtering: inactive schedules with configuration are now excluded
- Active schedules are now prioritized when assigning IPs and subnets
- Added comprehensive tests for reusability scenarios
```

**Why this is good**:
- High-level, describes WHAT and WHY
- No technical implementation details
- Focuses on business logic changes

## Bad Examples

```
DEF0799890: modify schedule reusability logic

- Added encoded query to filter non-reusable schedules
- Added orderByDesc('active') to prioritize active schedules
- Added 26 new tests for location-based scenarios
```

**Why this is bad**:
- Implementation details (encoded query, orderByDesc)
- Technical specifics that belong in code
- Line counts don't belong in commit messages
