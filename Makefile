INSTALL_TARGET_PROCESSES = SpringBoard
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:13.0:13.0
export THEOS_DEVICE_IP=192.168.168.121
export THEOS_DEVICE_PORT=22

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Central

Central_FILES = Tweak.x
Central_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += centralprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
