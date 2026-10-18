# Changelog

All notable changes to this repository are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and versions follow
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- The repository skeleton: the layout in `CATALOGUE.md` §3.12 — `text/`, the RFC
  template at the root and in `text/`, the licence files and `scripts/check.sh`.

### Changed

- Validation moved from a GitHub Actions workflow to `scripts/check.sh`: no workflow is
  committed, so a check runs on the machine that made the change.
