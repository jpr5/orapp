#
# $Id$
#

#######################
# Local Configuration #
#######################

ORACLE_VERSION  = 9
ORACLE_INCLUDES = -I$(ORACLE_HOME)/rdbms/demo -I$(ORACLE_HOME)/rdbms/public
ORACLE_LIBS     = $(ORACLE_HOME)/lib/libclntst$(ORACLE_VERSION).a \
	          $(ORACLE_HOME)/lib/libwtc$(ORACLE_VERSION).a

GEN_FLAGS    = -g -fno-exceptions -fno-rtti -D_REENTRANT=1 # -O2
GEN_INCLUDES =
GEN_LIBS     = -ldl
#GEN_LIBS    = -lnsl -lsocket -lz -ldl  # for solaris

CXXFLAGS = $(ORACLE_FLAGS) $(GEN_FLAGS)
INCLUDES = $(ORACLE_INCLUDES) $(GEN_INCLUDES) 
LIBS     = $(GEN_LIBS) $(ORACLE_LIBS) 

SRC=conn.cc constants.cc error.cc field.cc log.cc query.cc row.cc 
OBJ=$(SRC:.cc=.o)
TARGET=orapp


################
# Installation #
################

INSTALL_PREFIX  = /usr
INSTALL_HEADERS = $(INSTALL_PREFIX)/include/$(TARGET)
INSTALL_LIBS    = $(INSTALL_PREFIX)/lib/$(TARGET)


##############
# Main Rules #
##############

all: checkORACLE lib$(TARGET).a test

lib$(TARGET).a: $(OBJ)
	@rm -f $@
	ar rscv lib$(TARGET).a $(OBJ)

lib$(TARGET).so: checkORACLE $(OBJ)
	@rm -f $@
	gcc -shared -fPIC -o lib$(TARGET).so $(OBJ)

test: lib$(TARGET).a test.o
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $@ test.o -L. -l$(TARGET) $(LIBS) -lpthread

checkORACLE:
	@if test -z "$$ORACLE_HOME" ; then \
		echo "****************************************" ; \
		echo "* Set ORACLE_HOME before running make. *" ; \
		echo "****************************************" ; \
		exit 1; \
	fi

.cc.o:
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $<

$(OBJ): Makefile

dep depend depends:
	@rm -f .depends
	@echo making dependencies...
	@$(CXX) -M -MG $(CXXFLAGS) $(INCLUDES) $(SRC) > .depends

clean:
	rm -f *.o lib$(TARGET).* test

distclean: clean
	rm -f *~ core* .depends

install: all
	@echo 
	@echo Installing $(TARGET) into $(INSTALL_PREFIX) ...
	@echo
	@mkdir -p $(INSTALL_PREFIX)
	@mkdir -p $(INSTALL_HEADERS)
	@mkdir -p $(INSTALL_LIBS)
	@cp -fv $(SRC:.cc=.hh) orapp.hh        $(INSTALL_HEADERS)
	@if test -f lib$(TARGET).a; then  cp -fv lib$(TARGET).a  $(INSTALL_LIBS); fi
	@if test -f lib$(TARGET).so; then cp -fv lib$(TARGET).so $(INSTALL_LIBS); fi
	@echo
	@echo Complete.
	@echo

.PHONY: checkORACLE

-include .depends
