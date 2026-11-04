# Compute Module

This module provisions OCI Compute instances.

## Features

- Configurable OCI Compute shape.
- Flexible OCPU and memory configuration.
- Custom image selection.
- Public VNIC configuration.
- Network Security Group association.
- SSH public key injection.
- Configurable boot volume.
- Freeform resource tags.

## Current deployment

The Always Free environment uses:

- Shape: VM.Standard.A1.Flex
- Architecture: ARM64
- Operating System: Ubuntu 24.04 LTS
- OCPUs: 2
- Memory: 12 GB
- Boot Volume: 50 GB

## Security

SSH access is restricted through the associated Network Security Group.
