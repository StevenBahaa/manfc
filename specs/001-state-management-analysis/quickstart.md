# Quickstart: State Management Analysis

## Overview

This guide provides instructions on how to interpret and act upon the State Management Analysis report.

## Accessing the Report

Once the implementation phase (`speckit.implement`) is complete, the final analysis report will be generated and saved in this feature directory or presented directly.

## Acting on the Recommendation

1. **Review the Report**: Read the `architecture-report.md` (or equivalent output) to understand the current state of the codebase.
2. **Review the Recommendation**: Check the `recommendation.md` for the suggested state management approach.
3. **Plan Migration**: If you agree with the recommendation, create a new feature specification to plan and execute the migration. For example:
   ```bash
   /speckit.specify "Migrate state management to [Recommended Approach]"
   ```
