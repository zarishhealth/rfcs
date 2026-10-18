# rfcs

Requests for comments: the design decisions that are too large for a pull-request
description, written down before the code exists so that they can be argued about
while changing them is still cheap. `CATALOGUE.md` §3.12 has the layout.

```text
rfcs/
├── text/
│   └── NNNN-<kebab-title>.md      ← one file per RFC
├── 0000-template.md               ← the template, kept identical to text/0000-template.md
└── README.md
```

## Writing one

1. Copy `0000-template.md` to `text/NNNN-<kebab-title>.md` and take the next free
   number. Title in kebab case, no spaces: `0007-problem-type-uris.md`.
2. Fill it in. Leave nothing as "TBD" that a reviewer would need to decide.
3. Open a pull request. Discussion happens on the pull request; the file is the
   record, so edit it as the discussion moves.
4. On acceptance, set `Status: accepted` in the same pull request that records the
   decision.

An RFC that changes a rule in `BLUEPRINT.md` lands with the blueprint change, in the
same pull request. An RFC that settles a decision from `TODO.md` phase 0.1 says which
one in its header.

## Rules

- **A number is never reused.** Not for a rejected RFC, not for a withdrawn one, not
  for a typo. The gap is the history.
- One RFC, one subject. If it needs "and", it is two RFCs.
- An RFC is a proposal, not a contract: it is superseded by a later RFC rather than
  edited to say something different.
- Synthetic examples only, in every code block. No real patient data, no real person,
  no secret, no token, no real hostname.
- Permanent identifiers stay on `https://zarishhealth.github.io/...` until decision
  `D-09`; an RFC that proposes a domain change says so explicitly.

## Verify

```sh
scripts/check.sh                # markdown, links, naming, reuse, gitleaks
scripts/check.sh markdown       # only the named check
```

No workflow is committed. `markdown` checks that every fenced code block is closed and
`links` checks the links that point inside this repository (`lychee --offline`). A
tool that is missing is reported as **skipped**, never as passing.
