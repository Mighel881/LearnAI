TARGET = iphone:clang:latest:13.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = LearnAI
LearnAI_FILES = $(wildcard *.mm *.cpp)
LearnAI_FRAMEWORKS = UIKit CoreGraphics CorePlot
LearnAI_CFLAGS = -fobjc-arc -std=c++17 -stdlib=libc++ -Ilib/include -Wno-unused-variable
LearnAI_LDFLAGS = -Flib/frameworks -rpath /Applications/LearnAI.app/Frameworks
LearnAI_LIBRARIES = c++

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"LearnAI\"" || true
