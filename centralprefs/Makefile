include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Centralprefs

Centralprefs_FILES = CRLRootListController.m DuoTwitterCell.m
Centralprefs_INSTALL_PATH = /Library/PreferenceBundles
Centralprefs_FRAMEWORKS = UIKit
Centralprefs_PRIVATE_FRAMEWORKS = Preferences
Centralprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Centralprefs.plist$(ECHO_END)
