#!/bin/bash
set -ueo pipefail

if [ $# -ne 3 ] || [ ! -d "$1" ]; then
	printf '%s' "Usage ./$0 <modules dir> <kernelversion> <output file>" 1>&2
	exit 1
fi

if [ -e "$3" ]; then
	printf '%s' "Refusing to overwrite existing file $3" 1>&2
	exit 2
fi


# Inputs
SRC_DIR="$1"       # e.g., /path/to/rootfs
KERNEL_VER="$2"    # e.g., 6.14.5
OUTPUT_VHDX="$3"   # e.g., /path/to/modules.vhdx

# Temp dir for working space
tmp_dir=$(mktemp -d)
trap "losetup -d /dev/loop*" EXIT

# Calculate required size: actual + 256MiB slack
modules_size=$(du -bs "$SRC_DIR/lib/modules/$KERNEL_VER" | awk '{print $1}')
modules_size=$((modules_size + (256 * 1024 * 1024)))

# Create blank sparse image
img_path="$tmp_dir/modules.img"
truncate -s "$modules_size" "$img_path"

# Format image and mount it
loop_dev=$(losetup --find --show "$img_path")
mkfs.ext4 -q "$loop_dev"

mkdir "$tmp_dir/mnt"
mount "$loop_dev" "$tmp_dir/mnt"

# Copy kernel modules
rsync -a "$SRC_DIR/lib/modules/$KERNEL_VER/" "$tmp_dir/mnt/"

# Zero free space to allow sparse conversion
dd if=/dev/zero of="$tmp_dir/mnt/zero.fill" bs=1M || true
rm -f "$tmp_dir/mnt/zero.fill"
sync
umount "$tmp_dir/mnt"

# Convert to VHDX (sparse)
qemu-img convert -O vhdx -o subformat=dynamic "$img_path" "$OUTPUT_VHDX"

# Fix ownership since we're probably running under sudo
if [ -n "$SUDO_USER" ]; then
	chown "$SUDO_USER:$SUDO_USER" "$OUTPUT_VHDX"
fi
