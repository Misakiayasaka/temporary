# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/exTHmUI/android -b Tenshi -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/Misakiayasaka/local_manifest --depth=1 -b main .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch exthm_RMX2185-userdebug
export TZ=Asia/Bangkok #put before last build command
make reimu -j$(nproc --all)

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
