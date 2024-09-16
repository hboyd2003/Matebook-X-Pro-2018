# Matebook X Pro 2018 BIOS Unlock, Power Config and Archive
After my laptop served its life I wanted to turn it into a server, however, due to the severe power and cooling restrictions, I heavly modified the laptop to allow for more performance.
## BIOS Unlock
>[!WARNING]
>This tool is potentially dangerous and may brick your PC. Use at your **OWN** risk.
Due to secure flash and the Matebook X Pro's flash chip being LGA, this is a runtime mod which unlocks access to all BIOS settings.
The bios modifications lasts until reboot though settings are saved.

### Usage
This unlock/mod uses [SmokelessRuntimeEFIPatcher](https://github.com/hboyd2003/SmokelessRuntimeEFIPatcher)(SREP) which uses the `SREP_Config.cfg` to patch the BIOS.
[SmokelessRuntimeEFIPatcher](https://github.com/hboyd2003/SmokelessRuntimeEFIPatcher) is a (unsigned) EFI binary and can be ran using any standard method.

The `SREP_Config.cfg` file must be in the root of the drive where [SmokelessRuntimeEFIPatcher](https://github.com/hboyd2003/SmokelessRuntimeEFIPatcher) is ran from.

To boot from a USB drive:
1. The USB drive must be formated in a filesystem supported by your BIOS (Fat, Fat33, exFat usually work)
2. Create the folder structure below where BOOTX64.efi is the SREP binary renamed:
```
    SREP_Config.cfg
    EFI\boot\BOOTX64.efi
```
3. Boot the USB drive

# Power Config
> [!WARNING]
> This config **exceeds** the design characteristics of the VRM which may cause, overheating, laptop failure, fire, burns, or other damages.
> Use of this config is at your **OWN** risk. The repository owner and contributers are at not way responsible for any damages incured. This config was made with the laptop caseless and with substantial cooling upgrades for all components.

Since the BIOS can only set MSR limits not the MMIO power limits (and the CPU always chooses the lowest set limit), [PowerMonkey](https://github.com/psyq321/PowerMonkey) is used to set the limits. It must be compiled with the desired settings and as such, I have only uploaded `CONFIGURATION.c`. Follow the instructions from [PowerMonkey](https://github.com/psyq321/PowerMonkey) for more info.

> [!NOTE]
> `CONFIGURATION.c` may be out of date. You should compare and combine it with the most recent version.
> 

Like SREP it is a EFI binary and can be ran the same way, however, it does not boot the next EFI automatically. To apply the config at startup I set a EDK-2 shell (you can find pre-built binaries on google) to boot which then runs the `startup.nsh` script. The script runs `PowerMonkey.efi` and then runs `grubx64.efi`. The shell will find all EFI files that are in any folder within the EFI folder.

I was able to push the CPU and VRM quite far getting up to 36W (CPU Package) or 42W limit, however, it is a bit temperamental. At some points, due to unknown reasons a component sends a BD Prochot message to the CPU causing it to throttle. It's important to note that a component can send that message for any reason. I was not able to acertain the trigger for the message but I can confirm it is not temperature based. Frustratingly, as I continued to work on the BIOS mod and run tests, the limit at which the message would trigger changed to some degree. In the end I was no longer able it to run at a limit of 42W but settlest for 41W. Disable BD Prochot caused an immediare hard shutdown (underload).

# BIOS Archive
Look at the README in the BIOS archive folder for more information.

# Final Layout of the boot partition
For production I am running proxmox and booting to shellx64.efi (EDK-2 shell).
```
\
	SREP_Config.cfg
	EFI\
		BOOT\
			BOOTx64.efi
			fbx64.efi
			grubx64.efi
			mmx64.efi
		efi-shell\
			shellx64.efi
			startup.nsh
		proxmox\
			BOOTX64.csv
			fbx64.efi
			grub.cfg
			grubx64.efi
			mmx64.efi
			shimx64.efi
		tools\
			PowerMonkey.efi
			SREP.efi
```
