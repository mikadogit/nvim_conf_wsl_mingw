#
# Cross Platform Makefile
# Compatible with MSYS2/MINGW, Ubuntu  and Mac OS X
#
# Auteur : Mikael JOUANS 
# Version : V 1.0
#-------------------------------------------------------

# Changer CXX pour specifier un compilo C ou C++ 
# Changer CXXFLAGS pour specifier Flags C ou C++

########################################################
#--------------- CONFIGURATION -------------------------
########################################################
#The source file types (headers excluded).
# .c indicates C source files, and others C++ ones.
SRCEXTS = .c .C .cc .cpp .CPP .c++ .cxx .cp
# The header file types.
HDREXTS = .h .H .hh .hpp .HPP .h++ .hxx .hp .i

########################################################
# --------------- SPECIFICATION -------------------
########################################################
# The C++/C program compiler :  
CXX = /usr/bin/x86_64-w64-mingw32-g++

#The C++/C compilation flags : 
CXXFLAGS = -g3 -O0 -Wall -Wconversion -Wsign-conversion -fmessage-length=0
#The archive builder flages : 
ARFLAGS = 

#Bin name generation
EXE =Test_DUT_ARTIQ.exe

#Archive component : 
AR = 
#Lib NAME : 
LIBRARY = 

#Build destination
BUILDFOLDER =Debug_ARTIQ
#FOLDERS sources LIST (automatically processing)
#ex : SRCDIRS=. /home/Code/imgui /home/eclipse-workspace/Test/include/implot
SRCDIRS =	src \
			src/A/ \
			src/B
#FOLDERS headers LIST (automatically processing)
#ex : IDIR=/usr/local/SDL2-2.0.9/include /home/Code/imgui /home/eclipse-workspace/Test/include/implot
IDIR =	/mnt/c/msys64/mingw64/include \
		src \
		src/A \
		src/B 
#ADD Libs  : 
# ex : LIBS = -lGL -ldl `sdl2-config --libs`
LIBS =	-lformw \
		-lmenuw \
		-lncurses \
		-lPCANBasic \
		-lpython36 \
		-lws2_32 \
		-lm \
		-lversion\
		-lshlwapi
#LD FLags :
LDFLAGS =	-L/mnt/c/msys64/mingw64/lib 
#/!\ : use this variables to NOT include specific files : 
# ex : EXCLUDEFILES=/root/Code/imgui/backends/imgui_impl_dx9.cpp /root/Code/imgui/backends/imgui_impl_wgpu.cpp (file with path!!)          
EXCLUDEFILES=/
########################################################
#------------------- PRE PROCESSING --------------------
########################################################
RM     = rm -rf
SHELL   = /bin/sh
SPACE   = $(EMPTY) $(EMPTY)
ifeq ($(EXE),)
	CUR_PATH_NAMES = $(subst /,$(SPACE),$(subst $(SPACE),_,$(CURDIR)))
	EXE = $(word $(words $(CUR_PATH_NAMES)),$(CUR_PATH_NAMES))
		ifeq ($(EXE),)
			EXE = a.out
		endif
endif
ifeq ($(SRCDIRS),)
	SRCDIRS = .
endif
SOURCES = $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(SRCEXTS))))
HEADERS = $(foreach d,$(IDIR),$(wildcard $(addprefix $(d)/*,$(HDREXTS))))
#USEFULL for C compilation into C++ projects 
#SOURCES_EXC = $(filter-out %.c),$(SOURCES))

#Files to exclude :
SOURCES_EXC = $(filter-out $(EXCLUDEFILES),$(SOURCES)) 
OBJS = $(addsuffix .o, $(basename $(SOURCES_EXC)))	

INC_PARAM=$(foreach d, $(IDIR), -I$d)
#The C++ flags (with the include dir):
CXXFLAGS += $(INC_PARAM)
#absolute path to genere .o and bin into build folder
BUILDDIR = $(CURDIR)/$(BUILDFOLDER)
#object to compile in order to make the AR
AROBJ = $(addsuffix .o, $(basename $(AR)))


########################################################
#----------- BUILD FLAGS PER PLATFORM ------------------
########################################################
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Linux) #LINUX
	ECHO_MESSAGE = "Linux"
	# ex : LIBS += -lGL -ldl `sdl2-config --libs`
	#LIBS+= -lGL -ldl `sdl2-config --libs`
	# ex :CXXFLAGS += `sdl2-config --cflags`
	#CXXFLAGS += `sdl2-config --cflags`
	#file to exclude depending on OS
	#SOURCES_EXC = $(filter-out $(EXCLUDEFILES),$(SOURCES))
endif

ifeq ($(UNAME_S), Darwin) #APPLE
	ECHO_MESSAGE = "Mac OS X"
	#LIBS += -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo `sdl2-config --libs`
	#LIBS += -L/usr/local/lib -L/opt/local/lib
	#CXXFLAGS += `sdl2-config --cflags`
	#CXXFLAGS += -I/usr/local/include -I/opt/local/include
	#file to exclude depending on OS
	#SOURCES_EXC = $(filter-out $(EXCLUDEFILES),$(SOURCES))
endif

ifeq ($(OS), Windows_NT)
	ECHO_MESSAGE = "MinGW"
	#LIBS += -lgdi32 -lopengl32 -limm32 `pkg-config --static --libs sdl2`
	#CXXFLAGS += `pkg-config --cflags sdl2`
	#file to exclude depending on OS
	#SOURCES_EXC = $(filter-out $(EXCLUDEFILES),$(SOURCES))
endif

########################################################
# BUILD RULES
########################################################
.PHONY: dir objs all clean help show clean_obj ar clean_ar
.DEFAULT_GOAL := all
.SUFFIXES:
objs: $(OBJS) $(AROBJ)
%.o:%.c
	$(CXX) $(CXXFLAGS) -c -o $@ $<
		cp $@ $(BUILDDIR)/
%.o:%.C
	$(CXX) $(CXXFLAGS) -c -o $@ $<
		cp $@ $(BUILDDIR)/
%.o:%.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<
		cp $@ $(BUILDDIR)/
%.o:%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
		cp $@ $(BUILDDIR)/
%.o:%.CPP
	$(CXX) $(CXXFLAGS) -c -o $@ $<
		cp $@ $(BUILDDIR)/
%.o:%.c++
	$(CXX) $(CXXFLAGS) -c -o $@ $<
		cp $@ $(BUILDDIR)/
%.o:%.cp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
		cp $@ $(BUILDDIR)/
%.o:%.cxx
	$(CXX) $(CXXFLAGS) -c -o $@ $<
		cp $@ $(BUILDDIR)/

all: dir $(BUILDDIR)/$(EXE)
	@echo Build complete for $(ECHO_MESSAGE)
	
dir :
	mkdir -p $(BUILDDIR)
	
#all: $(EXE)
#	@echo Build complete for $(ECHO_MESSAGE)
	
#(BUILDDIR)/$(EXE): $(OBJS)
#	$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS) $(LIBS)
$(BUILDDIR)/$(EXE): $(OBJS)
	$(CXX) $(LDFLAGS) $^ $(LIBS) -o $@

#/!!!!\ DO NOT USE -j compilation (parallele) for building an archive !!
ar : dir $(LIBRARY)
$(LIBRARY) : $(AROBJ)
	ar $(ARFLAGS) $@ $(AROBJ)
	ranlib $@
	mv $@ $(BUILDDIR)

	
clean:
	$(RM) $(OBJS) $(BUILDDIR)

clean_obj:
	$(RM) $(OBJS)
	
clean_ar:
	$(RM) $(BUILDDIR)/$(LIBRARY)

help:
	@echo '  all       (=make) compile and link.'
	@echo '  ar        (=make) compile and build a library.'
	@echo '  clean     clean objects and the executable file.'
	@echo '  clean_obj clean objects only.'
	@echo '  clean_ar  clean archive.'
	@echo '  show      show variables (for debug use only).'
	@echo '  help      print this message.'
	@echo

show:
	@echo 'PROGRAM     :' $(EXE)
	@echo 'SRCDIRS     :' $(SRCDIRS)
	@echo 'HEADERS     :' $(HEADERS)
	@echo 'SOURCES     :' $(SOURCES_EXC)
	@echo 'LIBS        :' $(LIBS)
	@echo 'OBJS        :' $(OBJS)
	@echo 'EXLUDE      :' $(EXCLUDEFILES)

