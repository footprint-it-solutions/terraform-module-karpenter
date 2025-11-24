# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Use this section to track upcoming changes, to let people see what changes they might expect in
upcoming relases.

At release time, move the entries from here to a new release section.

## [1.2.1] - 2025-11-24

### Added

- Add support for configuring minimum node memory via `node_min_memory` variable

## [1.2.0] - 2025-11-21

### Added

- Add support for configuring block device mappings and volume size via `block_device_mappings` and `volume_size` variables

### Changed

- Refactored `blockDeviceMappings` in `values.yaml` to use a map (keyed by device name) instead of a list. This enables environment-specific overrides for individual volumes without redefining the entire list.

### Fixed

### Removed

## [1.1.1] - 2025-11-21

### Changed

- Bump chart version to ensure latest manifests are updated

## [1.1.0] - 2025-11-21

### Added

- Add mitigations for disk pressure

## [1.0.0] - 2025-11-20

### Added

- Initial release

### Changed

### Fixed

### Removed
