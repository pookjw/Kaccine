TARGET := iphone:clang:latest
INSTALL_TARGET_PROCESSES = SpringBoard KakaoTalk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Kaccine

$(TWEAK_NAME)_FRAMEWORKS = UIKit WebKit

$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-unused-variable -Wno-unused-function 

include $(THEOS_MAKE_PATH)/tweak.mk
