# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Introduced `excluded_instance_sizes` variable to allow configurable exclusion of AWS instance sizes (e.g. nano, micro, small, medium) from NodePools.
- Added consistent instance size requirements to all NodePools.
- Added `enable_al2023` and `enable_bottlerocket` variables to toggle NodePool and EC2NodeClass for each AMI family.
- Added support for custom UserData for both AL2023 and Bottlerocket via `al2023_userdata` and `bottlerocket_userdata`.
- Added `topologySpreadConstraints` and `extraRequirements` support for AL2023 and Bottlerocket NodePools.
- Integrated `nodePoolWeight` into NodePool specifications and exposed them as configurable Terraform variables.
- Improved YAML indentation for complex variables in `main.tf` to prevent syntax errors.
- Updated Bottlerocket AMI selector to use `bottlerocket@v1` alias.

### Removed

- Removed the previously introduced `minInstanceCpu` variable in favour of `excludedInstanceSizes`.
- Removed HLB configuration and related resources (NodePool and EC2NodeClass).

## [2.2.0] - 2025-02-04

### Added

- Add metadata options for ec2nodeclass with override for httpPutResponseHopLimit to allow access to Instance Metadata Service (IMDS) from EKS pods. 

## [2.1.1] - 2026-01-14

### Added

- Add support for multi-architecture instances

## [2.0.0] - 2025-12-05

### Added

- Add `startupTaints`, static mode node count and feature gates for StaticCapacity

### Changed

- Bump Karpenter version to `1.8.2` to set `spec.replicas: 1` because `replicas` is not a valid field in `1.7.1`.

## [1.5.0] - 2025-12-13

### Added

- Added node pool labels, for use with `nodeSelector`
- Added "g" instances to AL2023 node pool

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
