# CLAUDE.md — DBIC (formerly DBIx::Class)

This is the DBIC distribution — a modernized fork of DBIx::Class, the Perl ORM framework.

## Project Goals

1. **Namespace rename**: `DBIx::Class` → `DBIC` (all modules, tests, docs)
2. **SQL::Abstract::Classic → SQL::Abstract**: Use the modern SQL generation library
3. **No RIBASUSHI dependencies**: No runtime dependency on any module where RIBASUSHI is the sole/primary maintainer
4. **Dist::Zilla build system**: Replace Module::Install with dzil
5. **Comprehensive inline documentation**: Custom Pod::Weaver configuration

## Current Status

- **Phase 1 (In Progress)**: Namespace rename from DBIx::Class to DBIC
- Original codebase: 156 .pm files, 314 test files
- Build system: Still Module::Install (to be replaced with Dist::Zilla)

## Directory Structure

```
lib/DBIC/              # Main modules (target namespace)
lib/DBIC.pm            # Main module
lib/SQL/Translator/    # SQLT integration (Parser/Producer)
t/                     # Test suite (314 files)
xt/                    # Extended/author tests
script/                # Executables (dbicadmin)
examples/              # Example code
```

## RIBASUSHI Dependency Audit

These dependencies MUST NOT be used (RIBASUSHI is owner/primary maintainer):

| Banned Module | Replacement |
|---|---|
| `SQL::Abstract::Classic` | `SQL::Abstract` (by MSTROUT) |
| `namespace::clean` | `namespace::autoclean` (by ETHER) or removal |

These are OK (maintained by HAARG or others, RIBASUSHI only has historical co-maint):
- `Class::Accessor::Grouped` (HAARG)
- `Class::C3::Componentised` (HAARG)
- `Devel::GlobalDestruction` (HAARG)

## Key Architecture

### SQLMaker Layer

The SQL generation stack (critical for SQL::Abstract migration):

```
DBIC::SQLMaker                    # Nexus class
  ├── inherits: DBIC::SQLMaker::ClassicExtensions  # JOIN, GROUP BY, HAVING, LIMIT dialects
  └── inherits: SQL::Abstract     # (was SQL::Abstract::Classic)
```

DB-specific subclasses: `DBIC::SQLMaker::MSSQL`, `::MySQL`, `::Oracle`, `::SQLite`, `::ACCESS`

### Object System

Uses **Moo** (2.000+) as the primary object system, with `Class::Accessor::Grouped` for accessors and `Class::C3::Componentised` for component loading.

### Storage Layer

```
DBIC::Storage::DBI                # Main DBI storage
  ├── DBIC::Storage::DBI::Pg      # PostgreSQL
  ├── DBIC::Storage::DBI::mysql   # MySQL
  ├── DBIC::Storage::DBI::SQLite  # SQLite
  ├── DBIC::Storage::DBI::MSSQL   # MS SQL Server
  ├── DBIC::Storage::DBI::Oracle  # Oracle
  └── ... (15+ database drivers)
```

## Development Commands

### Testing (current, pre-dzil)

```bash
prove -l t/                     # Run all tests
prove -l t/specific_test.t      # Run a single test
prove -lv t/                    # Verbose output
DBICTEST_SQLT_DEPLOY=1 prove -l t/  # Include SQLT deploy tests
```

### Dependencies

```bash
cpanm --installdeps .           # Install deps (once cpanfile exists)
```

## Coding Conventions

- Use `mro 'c3'` (C3 method resolution order)
- `use strict; use warnings;` on every file
- `# ABSTRACT:` comment on every .pm file (for Pod::Weaver)
- Inline POD: `=attr`, `=method` style (once weaver is set up)
- No CPerl support (rejected in original, we maintain this stance)
- Minimum Perl version: To be decided (original was 5.008001, may raise)

## Distributions to Integrate

These external DBIx::Class distributions will be folded into DBIC core:

- **DBIx::Class::TimeStamp** (RIBASUSHI) → `DBIC::Timestamp`
- **DBIx::Class::Helpers** (FREW) → integrated into DBIC core (ResultSet helpers, Row helpers, etc.)
- More TBD

## Legacy Layers (Candidates for Removal)

- `DBIC::CDBICompat::*` — Class::DBI compatibility (23 modules) — likely removable
- `DBIC::SQLAHacks::*` — Old SQL customization layer — may be removable
- `DBIC::DB` — Legacy connection interface

## Namespace Rename Rules

When renaming DBIx::Class → DBIC:

1. `package DBIx::Class::Foo` → `package DBIC::Foo`
2. `use DBIx::Class::Foo` → `use DBIC::Foo`
3. `use base 'DBIx::Class::Foo'` → `use base 'DBIC::Foo'`
4. `DBIx::Class::Exception->throw` → `DBIC::Exception->throw`
5. String matches in `_skip_namespace_frames` regex patterns
6. POD references: `L<DBIx::Class::Foo>` → `L<DBIC::Foo>`
7. Error messages and diagnostic strings
8. Test file contents
9. Environment variable prefix: `DBICTEST_` stays (already uses DBIC prefix)
10. Script name `dbicadmin` stays

## Agents

Project-specific agents are in `.claude/agents/`. These are self-contained and do NOT reference agents from the parent workspace.

- `namespace-rename.md` — Handles batch renaming of DBIx::Class → DBIC
- `sqla-migration.md` — Handles SQL::Abstract::Classic → SQL::Abstract migration
- `dzil-setup.md` — Dist::Zilla configuration and build system setup
