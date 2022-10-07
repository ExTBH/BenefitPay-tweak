TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = BenefitPay


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BenefitPay

BenefitPay_FILES = Tweak.x
BenefitPay_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
