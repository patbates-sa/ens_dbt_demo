# Pre-session verification

Run in order. Each step has an expected result — if it does not match, stop there.

## 1. Connection

```bash
dbt deps
dbt debug
```

Expect `All checks passed!`. If SSO opens a browser tab, that is `authenticator: externalbrowser` working.

## 2. Staging

```bash
dbt build --select staging
```

Expect 9 models and roughly 25 tests, all pass. Failures here are almost always
a column-name mismatch between the generated CSVs and `_ens__sources.yml` — check
the actual columns with `describe table ENS_SANDBOX.RAW.ENS_INCIDENT;` and fix the
staging model rather than the source YAML.

## 3. Docs and lineage

```bash
dbt docs generate
```

Needed for column-level lineage in the catalog. Without a `docs generate` the
lineage view is incomplete, which would undercut the segment that depends on it.
