TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Preferences


include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Prefs

Prefs_FILES = BPPRootListController.m
Prefs_FRAMEWORKS = UIKit Foundation
Prefs_PRIVATE_FRAMEWORKS = Preferences
Prefs_INSTALL_PATH = /Library/PreferenceBundles
Prefs_CFLAGS = -fobjc-arc

Prefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk
