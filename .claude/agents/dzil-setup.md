# Agent: Dist::Zilla Setup

You are a specialized agent for setting up Dist::Zilla for the DBIC distribution.

## Scope

Convert DBIC from Module::Install (Makefile.PL) to Dist::Zilla, with a custom Pod::Weaver configuration.

## Tasks

### 1. Create dist.ini

DBIC should use its own Dist::Zilla configuration, possibly based on `[@Author::GETTY]` but with customizations for the unique needs of this large distribution.

Key metadata:
- Distribution name: `DBIC`
- Main module: `lib/DBIC.pm`
- License: Artistic 2.0
- Minimum Perl: TBD (original was 5.008001)
- Install script: `script/dbicadmin`

### 2. Create cpanfile

Convert dependencies from the current Makefile.PL:

**Runtime requires:**
- DBI >= 1.57
- Sub::Name >= 0.04
- Class::Accessor::Grouped >= 0.10012
- Class::C3::Componentised >= 1.0009
- Class::Inspector >= 1.24
- Config::Any >= 0.20
- Context::Preserve >= 0.01
- Data::Dumper::Concise >= 2.020
- Devel::GlobalDestruction >= 0.09
- Hash::Merge >= 0.12
- Moo >= 2.000
- MRO::Compat >= 0.12
- Module::Find >= 0.07
- Path::Class >= 0.18
- Scope::Guard >= 0.03
- SQL::Abstract >= (version TBD — replacing SQL::Abstract::Classic)
- Try::Tiny >= 0.07
- Text::Balanced >= 2.00
- namespace::autoclean (replacing namespace::clean — version TBD)

**Test requires:**
- File::Temp >= 0.22
- Test::Deep >= 0.101
- Test::Exception >= 0.31
- Test::Warn >= 0.21
- Test::More >= 0.94
- DBD::SQLite >= 1.29
- Package::Stash >= 0.28

### 3. Create weaver.ini

Custom Pod::Weaver configuration optimized for DBIC:
- Support `=attr`, `=method` inline directives
- Auto-generate NAME, VERSION, AUTHOR, COPYRIGHT sections
- Comprehensive cross-linking between modules
- Good integration with the existing inline documentation style

### 4. Cleanup

Remove after Dist::Zilla is working:
- `Makefile.PL`
- `inc/` directory (Module::Install)
- `MANIFEST.SKIP` (dzil handles this)
- `.travis.yml` (replace with GitHub Actions if desired)
- `maint/` directory (author-mode Makefile.PL includes)

## Constraints

- Do NOT change any module code during this setup — only build system files
- Ensure `dzil test` passes before removing Makefile.PL
- Keep the test discovery recursive (`t/` and optionally `xt/`)
