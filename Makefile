LD = $(CC)
# Other tools
DOXYGEN ?= doxygen
UNIFDEF ?= unifdef
CFLAGS = -O3 -march=native -Wall -Wno-unused-function -Wno-unused-label
LDFLAGS = -lpthread -lpmemobj

CPPFLAGS = -I$(INCDIR) -I$(SRCDIR)

CFLAGDBG = -g3 -O0

BINS = intset-hs intset-hs-pm intset-hs-pm-DB intset-ll intset-ll-pm intset-sl intset-sl-pm intset-sl-pm-DB

UNAME := $(shell uname)
ifeq ($(UNAME), SunOS)
# Solaris requires rt lib for nanosleep
LDFLAGS += -lrt
endif

.PHONY:	all clean

all:	$(BINS)

intset-hs.o:	intset.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEFINES) -DUSE_HASHSET -DNO_STM -c -o $@ $<

intset-hs-pm.o: intset.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEFINES) -DUSE_HASHSET -DNO_STM -DPERSISTENT -c -o $@ $<

intset-hs-pm-DB.o: intset.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEFINES) -DUSE_HASHSET -DNO_STM -DPERSISTENT -DDEBUG_PM_HS -c -o $@ $<

intset-ll.o:	intset.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEFINES) -DUSE_LINKEDLIST -DNO_STM -c -o $@ $<
	
intset-ll-pm.o: intset.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEFINES) -DUSE_LINKEDLIST -DNO_STM -DPERSISTENT -c -o $@ $<

intset-sl.o:	intset.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEFINES) -DUSE_SKIPLIST -DNO_STM -c -o $@ $<

intset-sl-pm.o:	intset.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEFINES) -DUSE_SKIPLIST -DNO_STM -DPERSISTENT -c -o $@ $<

intset-sl-pm-DB.o:	intset.c
	$(CC) $(CPPFLAGS) $(CFLAGDBG) $(DEFINES) -DUSE_SKIPLIST -DNO_STM -DPERSISTENT -DDEBUG_PM_SL -c -o $@ $<

# FIXME in case of ABI $(TMLIB) must be replaced to abi/...
$(BINS):	%:	%.o $(TMLIB)
	$(LD) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(BINS) *.o
