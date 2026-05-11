[[_TOC_]]
# Quantifiers: *, +, ?, {n}, {n,}, {n,m}
- * matches zero or more occurrences.
- + matches one or more occurrences.
- ? matches zero or one occurrence.
- {n} matches exactly n occurrences.
- {n,} matches n or more occurrences.
- {n,m} matches between n and m occurrences.
# Alternation: |
- pattern1|pattern2 matches pattern1 or pattern2.
# Grouping: (...)
- (pattern) groups patterns together.
# example
```bash
if [[ "$string" =~ ^(foo|bar)_\d{3}$ ]];
```
# Backreferences
- \n: Matches the previously captured group (parentheses).
  - Example: (\d{3})-(\d{3})-(\d{4}) captures three groups of digits separated by hyphens. You can use \1, \2, and \3 to reference them later.
# Assertions:
- \b: Matches a word boundary (space, punctuation, beginning/end of line).
- \B: Matches the negation of a word boundary (in the middle of a word). 
