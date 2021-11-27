# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Tremolite Kernel for Pixel 3a/3a XL
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=bonito
device.name2=sargo
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;


## AnyKernel boot install
dump_boot;

# Patch dtbo.img on custom ROMs
username="$(file_getprop /system/build.prop "ro.build.user")";
echo "Found user: $username";
case "$username" in
  "android-build") user=google;;
  *) user=custom;;
esac;
hostname="$(file_getprop /system/build.prop "ro.build.host")";
echo "Found host: $hostname";
case "$hostname" in
  *corp.google.com|abfarm*) host=google;;
  *) host=custom;;
esac;
if [ "$user" == "custom" -o "$host" == "custom" ]; then
  if [ ! -z /tmp/anykernel/dtbo.img ]; then
    ui_print " "; ui_print "You are on a custom ROM, patching kernel to remove verity...";
    $bin/magiskboot --dtb-patch /tmp/anykernel/dtbo.img;
    $bin/magiskboot --dtb-patch /tmp/anykernel/Image.lz4-dtb;
  fi;
else
  ui_print " "; ui_print "You are on stock, not patching kernel to remove verity!";
fi;

write_boot;
## end boot install


# shell variables
#block=vendor_boot;
#is_slot_device=1;
#ramdisk_compression=auto;

# reset for vendor_boot patching
#reset_ak;


## AnyKernel vendor_boot install
#split_boot; # skip unpack/repack ramdisk since we don't need vendor_ramdisk access

#flash_boot;
## end vendor_boot install

