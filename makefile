
TARGET := emu
BUILDDIR := build-$(TARGET)

# compiler flags, default libs to link against
COMPILEFLAGS := -g -O2 -Wall -W
CFLAGS :=
CPPFLAGS :=
ASMFLAGS :=
LDFLAGS :=
LDLIBS :=

UNAME := $(shell uname -s)
ARCH := $(shell uname -m)

# switch any platform specific stuff here
# ifeq ($(findstring CYGWIN,$(UNAME)),CYGWIN)
# ...
# endif
ifeq ($(UNAME),Darwin)
CC := clang
CPLUSPLUS := clang++
COMPILEFLAGS += -I/opt/local/include
OTOOL := otool
endif
ifeq ($(UNAME),Linux)
CC := clang
CPLUSPLUS := clang++
OBJDUMP := objdump
endif
NOECHO ?= @

CFLAGS += $(COMPILEFLAGS)
CPPFLAGS += $(COMPILEFLAGS)
ASMFLAGS += $(COMPILEFLAGS)

OBJS := \
	main.o \
	ihex.o \
	cpu.o \
	memory.o \
	system.o

OBJS += \
	cpu6809.o \
	system09.o \
	mc6850.o

OBJS := $(addprefix $(BUILDDIR)/,$(OBJS))

DEPS := $(OBJS:.o=.d)

.PHONY: all
all: $(BUILDDIR)/$(TARGET) $(BUILDDIR)/$(TARGET).lst

$(BUILDDIR)/$(TARGET):  $(OBJS)
	$(CPLUSPLUS) $(LDFLAGS) $(OBJS) -o $@ $(LDLIBS)

$(BUILDDIR)/$(TARGET).lst: $(BUILDDIR)/$(TARGET)
ifeq ($(UNAME),Darwin)
	$(OTOOL) -Vt $< | c++filt > $@
else
	$(OBJDUMP) -Cd $< > $@
endif

clean:
	rm -f $(OBJS) $(DEPS) $(TARGET)

spotless:
	rm -rf build-*

# makes sure the target dir exists
MKDIR = if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi

$(BUILDDIR)/%.o: %.c
	@$(MKDIR)
	@echo compiling $<
	$(NOECHO)$(CC) $(CFLAGS) -c $< -MD -MT $@ -MF $(@:%o=%d) -o $@

$(BUILDDIR)/%.o: %.cpp
	@$(MKDIR)
	@echo compiling $<
	$(NOECHO)$(CPLUSPLUS) $(CPPFLAGS) -c $< -MD -MT $@ -MF $(@:%o=%d) -o $@

$(BUILDDIR)/%.o: %.S
	@$(MKDIR)
	@echo compiling $<
	$(NOECHO)$(CC) $(ASMFLAGS) -c $< -MD -MT $@ -MF $(@:%o=%d) -o $@

ifeq ($(filter $(MAKECMDGOALS), clean), )
-include $(DEPS)
endif
