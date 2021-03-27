TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = mgtv

mgtv_FILES = Tweak.x utils/NSMutableAttributedString+Extention.m utils/NSString+Extention.m fps/YYWeakProxy.m fps/YYFPSLabel.m memory/QMemoryIncrease.mm
mgtv_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
