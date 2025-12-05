# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Use this section to track upcoming changes, to let people see what changes they might expect in
upcoming relases.

At release time, move the entries from here to a new release section.

## [2.0.0] - 2025-12-05

### Added

- Add `startupTaints` and static mode node count

### Changed

- Bump Karpenter version to `1.8.2` to set `spec.replicas: 1` because replicas is not a valid field in `1.7.1`.

## [1.4.0] - 2025-12-05

### Added

- Add g EC2 instances for GPU support with Bottlerocket

## [1.3.0] - 2025-11-24

### Added

- Add node pool weights, favour Bottlerocket

### Changed

- Always use the volume size from the block device mappings

### Removed

- Removed `volume_size` variable

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
