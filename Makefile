# This is the Makefile for freeglut MinGW. It builds the freeglut DLL, import
# library, and static library.

# Object files to create for the freeglut DLL
DYNOBJS = obj/dynamic/fg_callbacks.o \
          obj/dynamic/fg_cursor.o \
          obj/dynamic/fg_cursor_mswin.o \
          obj/dynamic/fg_display.o \
          obj/dynamic/fg_display_mswin.o \
          obj/dynamic/fg_ext.o \
          obj/dynamic/fg_ext_mswin.o \
          obj/dynamic/fg_font.o \
          obj/dynamic/fg_font_data.o \
          obj/dynamic/fg_gamemode.o \
          obj/dynamic/fg_gamemode_mswin.o \
          obj/dynamic/fg_geometry.o \
          obj/dynamic/fg_gl2.o \
          obj/dynamic/fg_init.o \
          obj/dynamic/fg_init_mswin.o \
          obj/dynamic/fg_input_devices.o \
          obj/dynamic/fg_input_devices_mswin.o \
          obj/dynamic/fg_joystick.o \
          obj/dynamic/fg_joystick_mswin.o \
          obj/dynamic/fg_main.o \
          obj/dynamic/fg_main_mswin.o \
          obj/dynamic/fg_menu.o \
          obj/dynamic/fg_menu_mswin.o \
          obj/dynamic/fg_misc.o \
          obj/dynamic/fg_overlay.o \
          obj/dynamic/fg_spaceball.o \
          obj/dynamic/fg_spaceball_mswin.o \
          obj/dynamic/fg_state.o \
          obj/dynamic/fg_state_mswin.o \
          obj/dynamic/fg_stroke_mono_roman.o \
          obj/dynamic/fg_stroke_roman.o \
          obj/dynamic/fg_structure.o \
          obj/dynamic/fg_structure_mswin.o \
          obj/dynamic/fg_teapot.o \
          obj/dynamic/fg_videoresize.o \
          obj/dynamic/fg_window.o \
          obj/dynamic/fg_window_mswin.o \
          obj/dynamic/resource.o \
          obj/dynamic/xparsegeometry_repl.o

# Object files to create for the freeglut static library
STATICOBJS = obj/static/fg_callbacks.o \
             obj/static/fg_cursor.o \
             obj/static/fg_cursor_mswin.o \
             obj/static/fg_display.o \
             obj/static/fg_display_mswin.o \
             obj/static/fg_ext.o \
             obj/static/fg_ext_mswin.o \
             obj/static/fg_font.o \
             obj/static/fg_font_data.o \
             obj/static/fg_gamemode.o \
             obj/static/fg_gamemode_mswin.o \
             obj/static/fg_geometry.o \
             obj/static/fg_gl2.o \
             obj/static/fg_init.o \
             obj/static/fg_init_mswin.o \
             obj/static/fg_input_devices.o \
             obj/static/fg_input_devices_mswin.o \
             obj/static/fg_joystick.o \
             obj/static/fg_joystick_mswin.o \
             obj/static/fg_main.o \
             obj/static/fg_main_mswin.o \
             obj/static/fg_menu.o \
             obj/static/fg_menu_mswin.o \
             obj/static/fg_misc.o \
             obj/static/fg_overlay.o \
             obj/static/fg_spaceball.o \
             obj/static/fg_spaceball_mswin.o \
             obj/static/fg_state.o \
             obj/static/fg_state_mswin.o \
             obj/static/fg_stroke_mono_roman.o \
             obj/static/fg_stroke_roman.o \
             obj/static/fg_structure.o \
             obj/static/fg_structure_mswin.o \
             obj/static/fg_teapot.o \
             obj/static/fg_videoresize.o \
             obj/static/fg_window.o \
             obj/static/fg_window_mswin.o \
             obj/static/xparsegeometry_repl.o

# Warnings to be raised by the C compiler
WARNS = -W -Wall -Wfloat-equal -Wundef -Wshadow -Wpointer-arith  \
        -Wcast-align -Wwrite-strings -Wconversion -Wsign-compare \
        -Waggregate-return -Wmissing-noreturn -Wmissing-format-attribute \
        -Wredundant-decls -Winline -Wdisabled-optimization

# Names of tools to use when building
CC = gcc
RC = windres
DLLTOOL = dlltool
AR = ar
RANLIB = ranlib

# Compiler and linker flags
DYNCFLAGS = -s -O2 -D FREEGLUT_EXPORTS -D NEED_XPARSEGEOMETRY_IMPL -D NDEBUG -D WINVER=0x0500 -Iinclude/
DYNLDFLAGS = -s -shared -lopengl32 -lgdi32 -lwinmm
STATICCFLAGS = -s -O2 -D FREEGLUT_STATIC -D NEED_XPARSEGEOMETRY_IMPL -D NDEBUG -D WINVER=0x0500 -Iinclude/

.PHONY: all clean

# Build DLL, import library, and static library by default
all: bin/freeglut.dll lib/libfreeglut.a lib/libfreeglut_static.a

# Delete all build output
clean:
	if exist bin\*          del /q bin\*
	if exist lib\*          del /q lib\*
	if exist obj\dynamic\*  del /q obj\dynamic\*
	if exist obj\static\*   del /q obj\static\*

# Create build output directories if they don't exist
bin lib obj/dynamic obj/static:
	@if not exist "$@" mkdir "$@"

# Compile object files for DLL
obj/dynamic/%.o: | obj/dynamic
	${CC} ${DYNCFLAGS} -c "$<" -o "$@"

# Compile resource file for DLL
obj/dynamic/resource.o: res/resource.rc | obj/dynamic
	${RC} "$<" -o "$@"

# Build the freeglut DLL
bin/freeglut.dll: ${DYNOBJS} | bin
	${CC} -o "$@" ${DYNOBJS} ${DYNLDFLAGS} -Wl,--subsystem,windows,--kill-at

# Build the import library using undecorated stdcall workaround (see http://www.transmissionzero.co.uk/computing/advanced-mingw-dll-topics/).
lib/libfreeglut.a: ${DYNOBJS} | lib
	${CC} -o lib\tmp.dll ${DYNOBJS} ${DYNLDFLAGS} -Wl,--subsystem,windows,--output-def,lib\tmp.def
	${DLLTOOL} --kill-at -d lib\tmp.def -D freeglut.dll -l "$@"
	del /q lib\tmp.dll lib\tmp.def

# Compile object files for static library
obj/static/%.o: | obj/static
	${CC} ${STATICCFLAGS} -c "$<" -o "$@"

# Build the freeglut static library
lib/libfreeglut_static.a: ${STATICOBJS} | lib
	${AR} r "$@" ${STATICOBJS}
	${RANLIB} "$@"

# Dependencies (generated by "gcc -MM")
obj/dynamic/fg_callbacks.o: src\fg_callbacks.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_cursor.o: src\fg_cursor.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_display.o: src\fg_display.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_ext.o: src\fg_ext.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/dynamic/fg_font.o: src\fg_font.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/dynamic/fg_font_data.o: src\fg_font_data.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_gamemode.o: src\fg_gamemode.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_geometry.o: src\fg_geometry.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h src\fg_gl2.h
obj/dynamic/fg_gl2.o: src\fg_gl2.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h src\fg_gl2.h
obj/dynamic/fg_init.o: src\fg_init.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/dynamic/fg_input_devices.o: src\fg_input_devices.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_joystick.o: src\fg_joystick.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_main.o: src\fg_main.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/dynamic/fg_menu.o: src\fg_menu.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/dynamic/fg_misc.o: src\fg_misc.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/dynamic/fg_overlay.o: src\fg_overlay.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_spaceball.o: src\fg_spaceball.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_state.o: src\fg_state.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_stroke_mono_roman.o: src\fg_stroke_mono_roman.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_stroke_roman.o: src\fg_stroke_roman.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_structure.o: src\fg_structure.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_teapot.o: src\fg_teapot.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h src\fg_teapot_data.h
obj/dynamic/fg_videoresize.o: src\fg_videoresize.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/dynamic/fg_window.o: src\fg_window.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h src\fg_gl2.h
obj/dynamic/fg_cursor_mswin.o: src\mswin\fg_cursor_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_display_mswin.o: src\mswin\fg_display_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_ext_mswin.o: src\mswin\fg_ext_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_gamemode_mswin.o: src\mswin\fg_gamemode_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_init_mswin.o: src\mswin\fg_init_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_input_devices_mswin.o: src\mswin\fg_input_devices_mswin.c \
 include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\mswin\../fg_internal.h \
 src\mswin\../fg_version.h src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_joystick_mswin.o: src\mswin\fg_joystick_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_main_mswin.o: src\mswin\fg_main_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_menu_mswin.o: src\mswin\fg_menu_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_spaceball_mswin.o: src\mswin\fg_spaceball_mswin.c \
 include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\mswin\../fg_internal.h \
 src\mswin\../fg_version.h src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_state_mswin.o: src\mswin\fg_state_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_structure_mswin.o: src\mswin\fg_structure_mswin.c \
 include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\mswin\../fg_internal.h \
 src\mswin\../fg_version.h src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/fg_window_mswin.o: src\mswin\fg_window_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/dynamic/xparsegeometry_repl.o: src\util\xparsegeometry_repl.c \
 src\util\xparsegeometry_repl.h

obj/static/fg_callbacks.o: src\fg_callbacks.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_cursor.o: src\fg_cursor.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_display.o: src\fg_display.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_ext.o: src\fg_ext.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/static/fg_font.o: src\fg_font.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/static/fg_font_data.o: src\fg_font_data.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_gamemode.o: src\fg_gamemode.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_geometry.o: src\fg_geometry.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h src\fg_gl2.h
obj/static/fg_gl2.o: src\fg_gl2.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h src\fg_gl2.h
obj/static/fg_init.o: src\fg_init.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/static/fg_input_devices.o: src\fg_input_devices.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_joystick.o: src\fg_joystick.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_main.o: src\fg_main.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/static/fg_menu.o: src\fg_menu.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/static/fg_misc.o: src\fg_misc.c include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\fg_internal.h src\fg_version.h \
 src\mswin/fg_internal_mswin.h
obj/static/fg_overlay.o: src\fg_overlay.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_spaceball.o: src\fg_spaceball.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_state.o: src\fg_state.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_stroke_mono_roman.o: src\fg_stroke_mono_roman.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_stroke_roman.o: src\fg_stroke_roman.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_structure.o: src\fg_structure.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_teapot.o: src\fg_teapot.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h src\fg_teapot_data.h
obj/static/fg_videoresize.o: src\fg_videoresize.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h
obj/static/fg_window.o: src\fg_window.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h src\fg_internal.h \
 src\fg_version.h src\mswin/fg_internal_mswin.h src\fg_gl2.h
obj/static/fg_cursor_mswin.o: src\mswin\fg_cursor_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_display_mswin.o: src\mswin\fg_display_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_ext_mswin.o: src\mswin\fg_ext_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_gamemode_mswin.o: src\mswin\fg_gamemode_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_init_mswin.o: src\mswin\fg_init_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_input_devices_mswin.o: src\mswin\fg_input_devices_mswin.c \
 include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\mswin\../fg_internal.h \
 src\mswin\../fg_version.h src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_joystick_mswin.o: src\mswin\fg_joystick_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_main_mswin.o: src\mswin\fg_main_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_menu_mswin.o: src\mswin\fg_menu_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_spaceball_mswin.o: src\mswin\fg_spaceball_mswin.c \
 include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\mswin\../fg_internal.h \
 src\mswin\../fg_version.h src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_state_mswin.o: src\mswin\fg_state_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_structure_mswin.o: src\mswin\fg_structure_mswin.c \
 include/GL/freeglut.h include/GL/freeglut_std.h \
 include/GL/freeglut_ext.h src\mswin\../fg_internal.h \
 src\mswin\../fg_version.h src\mswin\../mswin/fg_internal_mswin.h
obj/static/fg_window_mswin.o: src\mswin\fg_window_mswin.c include/GL/freeglut.h \
 include/GL/freeglut_std.h include/GL/freeglut_ext.h \
 src\mswin\../fg_internal.h src\mswin\../fg_version.h \
 src\mswin\../mswin/fg_internal_mswin.h
obj/static/xparsegeometry_repl.o: src\util\xparsegeometry_repl.c \
 src\util\xparsegeometry_repl.h
