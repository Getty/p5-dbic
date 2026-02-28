# Agent: SQL::Abstract Migration

You are a specialized agent for migrating DBIC from SQL::Abstract::Classic to SQL::Abstract.

## Scope

Replace all usage of `SQL::Abstract::Classic` with `SQL::Abstract` (the modern version maintained by MSTROUT).

## Key Files

- `lib/DBIC/SQLMaker.pm` — Main nexus class, inherits from SQL::Abstract::Classic
- `lib/DBIC/SQLMaker/ClassicExtensions.pm` — Extensions layer (JOIN, GROUP BY, LIMIT dialects)
- `lib/DBIC/SQLMaker/*.pm` — Database-specific SQLMaker subclasses
- `lib/DBIC/Storage/DBI.pm` — Creates SQLMaker instances
- `lib/DBIC/Storage/DBIHacks.pm` — SQL generation hacks

## Migration Steps

### 1. Change inheritance in SQLMaker.pm

```perl
# Before:
use base qw(
  DBIC::SQLMaker::ClassicExtensions
  SQL::Abstract::Classic
);

# After:
use base qw(
  DBIC::SQLMaker::ClassicExtensions
  SQL::Abstract
);
```

### 2. API Compatibility Check

SQL::Abstract (modern) and SQL::Abstract::Classic share most of the core API but differ in:
- Some deprecated features removed in modern SQLA (like `-nest`)
- `_where_op_NEST` in ClassicExtensions — needs removal or adaptation
- Method signatures may differ slightly
- The `logic` and `convert` options are not in modern SQLA

### 3. ClassicExtensions Adaptation

The ClassicExtensions module already overrides many SQLA methods. Check that all overridden methods still exist in the new SQL::Abstract base class:
- `_quote`
- `_table`
- `_order_by`
- `_order_by_chunks`
- `_recurse_where`
- `_insert_returning`
- `_assert_bindval_matches_bindtype`
- `_sqlcase`

### 4. Test Validation

Run the SQL-related tests to verify:
```bash
prove -lv t/sqlmaker/
prove -lv t/search/
prove -lv t/storage/
```

## Constraints

- The SQLMaker must remain swappable per-schema (existing design guarantee)
- Database-specific subclasses must continue to work
- All existing test queries must produce identical SQL output
