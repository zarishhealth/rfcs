# AGENTS.md — rfcs

**Scope:** this repository. The workspace rules are in
`/home/healthbgd/zarishhealth/GOVERNANCE.md`; where the two disagree, the stricter
rule wins. `CATALOGUE.md` §3.12 has the layout.

## Verify

```sh
scripts/check.sh            # markdown, links, naming, reuse, gitleaks
scripts/check.sh markdown   # only the named check
```

## Cautions

- **A number is never reused.** A rejected or withdrawn RFC leaves its number spent.
- `0000-template.md` and `text/0000-template.md` must stay identical; edit both, or
  edit one and copy it over the other.
- An RFC that changes a rule in `BLUEPRINT.md` changes the blueprint in the same pull
  request. Do not leave the two disagreeing.
- Synthetic examples only: no real patient data, no real person, no secret, no token,
  no real hostname in a code block.
- Permanent identifiers stay on `https://zarishhealth.github.io/...` until `D-09`.
