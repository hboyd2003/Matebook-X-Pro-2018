@echo -off

if available(PowerMonkey.efi) then
    echo "PowerMonkey is available"
else
    echo "ERROR: PowerMonkey is not available"
    echo "Continue to ignore and boot to GRUB"
    pause
    goto GRUB
endif

echo "Running PowerMonkey..."
PowerMonkey

:GRUB
if available(grubx64.efi) then
    echo "GRUB is available. Running it..."
    grubx64
else
    echo "ERROR: GRUB is not available on path or current directory"
    echo "Aborting script!"
endif
