ARCHS = arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = LearnAI

LearnAI_FILES = $(wildcard *.mm *.cpp)
LearnAI_FRAMEWORKS = UIKit CoreGraphics
LearnAI_CFLAGS = -fobjc-arc -Wno-unguarded-availability-new

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"LearnAI\"" || true
