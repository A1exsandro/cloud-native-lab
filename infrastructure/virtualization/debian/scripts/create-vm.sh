#!/usr/bin/env bash

set -Eeuo pipefail

# Cloud Native Lab - Debian 13 VM Provisioning

LIBVIRT_URI="qemu:///system"

VM_NAME="${VM_NAME:-cnl-debian13-node01}"
VM_MEMORY="${VM_MEMORY:-3072}"
VM_VCPUS="${VM_VCPUS:-2}"
VM_DISK_SIZE="${VM_DISK_SIZE:-30}"

ISO_PATH="/var/lib/libvirt/boot/debian-13.7.0-amd64-netinst.iso"
DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"

NETWORK="default"
STORAGE_POOL="default"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PRESEED_TEMPLATE="${SCRIPT_DIR}/../preseed/preseed.cfg"
SSH_PUBLIC_KEY="${HOME}/.ssh/id_rsa.pub"

TEMP_DIR=""

cleanup() {
    unset VM_PASSWORD VM_PASSWORD_CONFIRM PASSWORD_HASH SSH_PUBLIC_KEY_B64

    if [[ -n "${TEMP_DIR}" && -d "${TEMP_DIR}" ]]; then
        rm -rf -- "${TEMP_DIR}"
    fi
}

trap cleanup EXIT

error() {
    echo "ERROR: $*" >&2
    exit 1
}

echo "======================================"
echo " Cloud Native Lab - Debian Provisioning"
echo "======================================"

echo "VM:       ${VM_NAME}"
echo "Memory:   ${VM_MEMORY} MB"
echo "vCPUs:    ${VM_VCPUS}"
echo "Disk:     ${VM_DISK_SIZE} GB"
echo "Network:  ${NETWORK}"
echo

# --------------------------------------------------
# 1. Validate prerequisites
# --------------------------------------------------

echo "[1/6] Validating prerequisites..."

for cmd in virsh virt-install openssl base64 python3 ssh-keygen; do
    command -v "${cmd}" >/dev/null 2>&1 || error "${cmd} not found."
done

[[ "${VM_NAME}" =~ ^[a-zA-Z0-9_.-]+$ ]] || error "Invalid VM name."
[[ "${VM_MEMORY}" =~ ^[0-9]+$ ]] || error "Invalid memory value."
[[ "${VM_VCPUS}" =~ ^[0-9]+$ ]] || error "Invalid vCPU value."
[[ "${VM_DISK_SIZE}" =~ ^[0-9]+$ ]] || error "Invalid disk size."

(( VM_MEMORY > 0 )) || error "Memory must be greater than zero."
(( VM_VCPUS > 0 )) || error "vCPUs must be greater than zero."
(( VM_DISK_SIZE > 0 )) || error "Disk size must be greater than zero."

[[ -r "${ISO_PATH}" ]] || error "Debian ISO not accessible: ${ISO_PATH}"
[[ -r "${PRESEED_TEMPLATE}" ]] || error "Preseed template not found."
[[ -r "${SSH_PUBLIC_KEY}" ]] || error "SSH public key not found: ${SSH_PUBLIC_KEY}"

ssh-keygen -lf "${SSH_PUBLIC_KEY}" >/dev/null 2>&1 \
    || error "Invalid SSH public key."

virsh -c "${LIBVIRT_URI}" net-info "${NETWORK}" >/dev/null \
    || error "Libvirt network ${NETWORK} unavailable."

virsh -c "${LIBVIRT_URI}" pool-info "${STORAGE_POOL}" >/dev/null \
    || error "Libvirt storage pool ${STORAGE_POOL} unavailable."

if virsh -c "${LIBVIRT_URI}" dominfo "${VM_NAME}" >/dev/null 2>&1; then
    error "VM ${VM_NAME} already exists."
fi

if [[ -e "${DISK_PATH}" ]]; then
    error "Disk already exists: ${DISK_PATH}"
fi

# --------------------------------------------------
# 2. Request password and generate SHA-512 hash
# --------------------------------------------------

echo
echo "[2/6] Configure VM administrator password."

read -r -s -p "Password for cnladmin: " VM_PASSWORD
echo

read -r -s -p "Confirm password: " VM_PASSWORD_CONFIRM
echo

[[ -n "${VM_PASSWORD}" ]] || error "Password cannot be empty."

[[ "${VM_PASSWORD}" == "${VM_PASSWORD_CONFIRM}" ]] \
    || error "Passwords do not match."

PASSWORD_HASH="$(printf '%s' "${VM_PASSWORD}" | openssl passwd -6 -stdin)"

[[ "${PASSWORD_HASH}" == '$6$'* ]] \
    || error "Could not generate SHA-512 password hash."

unset VM_PASSWORD VM_PASSWORD_CONFIRM

# --------------------------------------------------
# 3. Encode SSH public key
# --------------------------------------------------

echo
echo "[3/6] Preparing SSH public key..."

SSH_PUBLIC_KEY_B64="$(base64 -w 0 "${SSH_PUBLIC_KEY}")"

# --------------------------------------------------
# 4. Generate temporary Preseed
# --------------------------------------------------

echo
echo "[4/6] Generating temporary Preseed..."

TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/cnl-preseed.XXXXXX")"
chmod 0700 "${TEMP_DIR}"

TEMP_PRESEED="${TEMP_DIR}/preseed.cfg"

export PASSWORD_HASH SSH_PUBLIC_KEY_B64

python3 - "${PRESEED_TEMPLATE}" "${TEMP_PRESEED}" <<'PY'
import os
import sys
from pathlib import Path

source = Path(sys.argv[1])
destination = Path(sys.argv[2])

content = source.read_text(encoding="utf-8")

replacements = {
    "__USER_PASSWORD_CRYPTED__": os.environ["PASSWORD_HASH"],
    "__SSH_PUBLIC_KEY_B64__": os.environ["SSH_PUBLIC_KEY_B64"],
}

for placeholder, value in replacements.items():
    if content.count(placeholder) != 1:
        raise SystemExit(
            f"Expected exactly one occurrence of {placeholder}"
        )

    content = content.replace(placeholder, value)

if "__USER_PASSWORD_CRYPTED__" in content:
    raise SystemExit("Password placeholder was not replaced.")

if "__SSH_PUBLIC_KEY_B64__" in content:
    raise SystemExit("SSH key placeholder was not replaced.")

destination.write_text(content, encoding="utf-8")
destination.chmod(0o600)
PY

unset PASSWORD_HASH SSH_PUBLIC_KEY_B64

# --------------------------------------------------
# 5. Provision VM
# --------------------------------------------------

echo
echo "[5/6] Creating Debian 13 VM..."

virt-install \
    --connect "${LIBVIRT_URI}" \
    --name "${VM_NAME}" \
    --osinfo debian13 \
    --memory "${VM_MEMORY}" \
    --vcpus "${VM_VCPUS}" \
    --cpu host-passthrough \
    --disk "path=${DISK_PATH},size=${VM_DISK_SIZE},format=qcow2,bus=virtio" \
    --network "network=${NETWORK},model=virtio" \
    --graphics none \
    --console pty,target_type=serial \
    --location "${ISO_PATH}" \
    --initrd-inject "${TEMP_PRESEED}" \
    --extra-args "auto=true priority=critical preseed/file=/preseed.cfg console=ttyS0,115200n8"

# --------------------------------------------------
# 6. Finish
# --------------------------------------------------

echo
echo "[6/6] Provisioning command completed."
echo
echo "VM: ${VM_NAME}"
echo
echo "Check status with:"
echo "virsh -c ${LIBVIRT_URI} list --all"
