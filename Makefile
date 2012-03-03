include theos/makefiles/common.mk

BUNDLE_NAME = NCExample
NCExample_FILES = NCExampleController.m
NCExample_INSTALL_PATH = /System/Library/WeeAppPlugins
NCExample_FRAMEWORKS = UIKit, Twitter

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
