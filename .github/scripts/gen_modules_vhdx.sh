#!/bin/bash
set -ueo pipefail

if [ $# -ne 3 ] || [ ! -d "$1" ]; then
    printf '%s\n' "Usage: $0 <modules dir> <kernelversion> <output file>" >&2
    exit 1
fi

if [ -e "$3" ]; then
    printf '%s\n' "Refusing to overwrite existing file $3" >&2
    exit 2
fi

SRC_DIR="$1"
KERNEL_VER="$2"
OUTPUT_VHDX="$3"

tmp_dir=$(mktemp -d)
mount_point="$tmp_dir/mnt"
img_path="$tmp_dir/modules.img"
loop_dev=""

# Clean up properly on exit
cleanup() {
    if mountpoint -q "$mount_point"; then
        umount "$mount_point" || true
    fi
    if [ -n "$loop_dev" ] && losetup "$loop_dev" &>/dev/null; then
        losetup -d "$loop_dev" || true
    fi
    rm -rf "$tmp_dir"
}
trap cleanup EXIT

# Estimate image size (+512MiB buffer)
modules_size=$(du -bs "$SRC_DIR/lib/modules/$KERNEL_VER" | awk '{print $1}')
modules_size=$((modules_size + 512 * 1024 * 1024))

# Round up to 4 KiB boundary
remainder=$((modules_size % 4096))
if [ "$remainder" -ne 0 ]; then
    modules_size=$((modules_size + 4096 - remainder))
fi

truncate -s "$modules_size" "$img_path"

# Set up loop device
loop_dev=$(losetup --find --show "$img_path")
mkfs.ext4 -q "$loop_dev"

mkdir -p "$mount_point"
mount "$loop_dev" "$mount_point"

# Copy kernel modules
rsync -a "$SRC_DIR/lib/modules/$KERNEL_VER/" "$mount_point/"

# Zero unused space
dd if=/dev/zero of="$mount_point/zero.fill" bs=1M || true
rm -f "$mount_point/zero.fill"
sync
umount "$mount_point"

# Convert to VHDX
qemu-img convert -O vhdx -o subformat=dynamic "$img_path" "$OUTPUT_VHDX"

# Fix ownership if using sudo
if [ -n "${SUDO_USER:-}" ]; then
    chown "$SUDO_USER:$SUDO_USER" "$OUTPUT_VHDX"
fi