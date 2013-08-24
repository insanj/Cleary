TARGET=:clang
include theos/makefiles/common.mk

TWEAK_NAME = Cleary
Cleary_OBJC_FILES = Cleary.xm
Cleary_FRAMEWORKS = Foundation UIKit
Cleary_LDFLAGS = -lactivator -Ltheos/lib
SUBPROJECTS += CLPreferences

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/bundle.mk
