#!/bin/bash

# Get list of USB drives using lsblk and filter by removable drives (RM=1)
usb_devices=($(lsblk -o NAME,RM,SIZE,MODEL,TRAN | awk '$2 == 1 {print $1}'))

# Check if any USB devices were found
if [ ${#usb_devices[@]} -eq 0 ]; then
    echo "No USB devices found."
    exit 1
fi

echo "Available USB devices:"
for i in "${!usb_devices[@]}"; do
    dev="${usb_devices[$i]}"
    info=$(lsblk -o NAME,SIZE,MODEL,MOUNTPOINT | grep "^$dev")
    echo "$i) /dev/$dev - $info"
done

# Ask user to select a device
read -p "Select a USB device by number: " choice

# Validate selection
if [[ ! "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -ge "${#usb_devices[@]}" ]; then
    echo "Invalid selection."
    exit 1
fi

selected="/dev/${usb_devices[$choice]}"
echo "You selected: $selected"

# Example action (uncomment one if needed)
# echo "Mounting $selected..."
# sudo mount $selected /mnt

# echo "Unmounting $selected..."
# sudo umount $selected

# echo "Copying a file to $selected..."
# sudo cp myfile.txt $selected

exit 0

