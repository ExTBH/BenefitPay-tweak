TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = BenefitPay


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BenefitPay

BenefitPay_FILES = Tweak.m
BenefitPay_CFLAGS = -fobjc-arc
BenefitPay_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
