ARCHS = armv7 arm64
TARGET = :clang::6.0
include theos/makefiles/common.mk
SYSROOT=/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk
BUNDLE_NAME = DogFanWallpaper
DogFanWallpaper_FILES = DogFanWallpaper.mm
DogFanWallpaper_INSTALL_PATH = /Library/PreferenceBundles
DogFanWallpaper_FRAMEWORKS = UIKit
DogFanWallpaper_PRIVATE_FRAMEWORKS = Preferences
IP_ADDRESS=192.168.1.139
include $(THEOS_MAKE_PATH)/bundle.mk


internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DogFanWallpaper.plist$(ECHO_END)
	rsync -z _/Library/PreferenceBundles/DogFanWallpaper.bundle/* root@$(IP_ADDRESS):/Library/PreferenceBundles/DogFanWallpaper.bundle/
	
	ssh root@$(IP_ADDRESS) killall Preferences
	
sync: stage
	rsync -r -z _/Library/PreferenceBundles/DogFanWallpaper.bundle/* root@$(IP_ADDRESS):/Library/PreferenceBundles/DogFanWallpaper.bundle/
	rsync -z _/Library/PreferenceLoader/Preferences/DogFanWallpaper.plist root@$(IP_ADDRESS):/Library/PreferenceLoader/Preferences/DogFanWallpaper.plist
	ssh root@$(IP_ADDRESS) killall Preferences