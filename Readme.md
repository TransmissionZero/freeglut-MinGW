# freeglut MinGW

## Table of Contents

- [Introduction](#introduction)
- [freeglut MinGW Build](#freeglut-mingw-build)
- [Building the Library](#building-the-library)
- [Testing the Library](#testing-the-library)
- [Terms of Use](#terms-of-use)
- [Problems?](#problems)
- [Changelog](#changelog)

## Introduction

(taken from the [freeglut web site](http://freeglut.sourceforge.net/))

FreeGLUT is a free-software/open-source alternative to the OpenGL Utility
Toolkit (GLUT) library. GLUT was originally written by Mark Kilgard to support
the sample programs in the second edition OpenGL 'RedBook'. Since then, GLUT has
been used in a wide variety of practical applications because it is simple,
widely available and highly portable.

GLUT (and hence FreeGLUT) takes care of all the system-specific chores required
for creating windows, initializing OpenGL contexts, and handling input events,
to allow for trully portable OpenGL programs.

## freeglut MinGW Build

freeglut MinGW is a repackaging of the freeglut source code. It removes the
non-Windows source code and adds a Makefile which can be used to build freeglut
with MinGW. The reason for this is because Transmission Zero produces
[freeglut Windows Development Libraries](http://www.transmissionzero.co.uk/software/freeglut-devel/)
for MinGW and MSVC. It was considered important for those two packages to be
binary compatible with each other, and also with the original GLUT for Win32.
The Makefile pulls off a few tricks to make this happen (see
[Advanced MinGW DLL Topics](http://www.transmissionzero.co.uk/computing/advanced-mingw-dll-topics/)
).

There are no functional changes from the official freeglut release, but the
resource script has been modified to identify the DLL as the Transmission Zero
MinGW build. Therefore you can assume that (e.g.) freeglut MinGW v3.0.0-1.tz
functions exactly the same as freeglut v3.0.0.

Note that this source release is not an official release, and is not endorsed by
the freeglut project. For official source releases, please visit the downloads
section of the [freeglut web site](http://freeglut.sourceforge.net/).

## Building the Library

To build the application from the command line with the MinGW C compiler, open a
command prompt, change to the directory containing the Makefile, and run
"mingw32-make". This will produce the freeglut DLL in the "bin" directory, and
the import and static libraries in the "lib" directory. Additionally, you will
need the contents of the "include" directory (include the "GL" directory as-is,
don't try to flatten it).

You can build both x86 and x64 versions of freeglut from the Makefile. The
undecorated stdcall workaround is actually an unnecessary step in a 64 bit
build, as x64 functions are neither decorated nor stdcall. You could modify the
Makefile to produce the x64 DLL and import library in a single step and remove
the stdcall workaround. However, apart from wasting a few CPU cycles, the
workaround is harmless to the 64 bit build, and leaving it there ensures both 32
bit and 64 bit builds are correct.

You can also cross-compile freeglut, e.g. by using MinGW on the Fedora Linux
distribution. Some small tweaks will likely be needed in the Makefile to do
this.

## Testing the Library

To test the library, you can build the
[Hello GLUT](https://github.com/TransmissionZero/Hello-GLUT) application.

## Terms of Use

FreeGLUT is released under the X-Consortium license. Refer to "License.txt" for
terms of use.

## Problems?

If you have any problems or questions, please ensure you have read this readme
file and the
[Using freeglut or GLUT with MinGW](http://www.transmissionzero.co.uk/computing/using-glut-with-mingw/)
article. If you are still having trouble, you can
[get in contact](http://www.transmissionzero.co.uk/contact/).

## Changelog

1. 2016-08-29: Version 3.0.0-1.tz
  - Initial public source release.

Transmission Zero
2016-08-29
