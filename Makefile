# 2026-11-11

################################################################################
# Targetit

.PHONY: all
.PHONY: build
.PHONY: clean
.PHONY: clear
.PHONY: show
.PHONY: send
.PHONY: list


################################################################################
# Perusmääritykset

SHELL=/bin/bash

# Kohteen suoritinarkkitehtuuri
MMCU=attiny10
TARGET_ARCH=avrtiny

# Lähdekoodikansio
KOODIKANSIO=src

# Tulokset
KOHDEKANSIO=build_artifacts
KOHDEBIN=$(KOHDEKANSIO)/ulos.bin
KOHDE_ELF=$(KOHDEKANSIO)/ulos.elf


################################################################################
# Kääntäjä, linkkeri ymv työkalut

# Kirjastot jotka otetaan mukaan
LIBS :=

# C-kääntäjä ja sen vaatimat argumentit
COMP_CC=avr-gcc
COMPFLAGS_C:=-mmcu=$(MMCU) -Os -c -MMD -MP -I lib -I include/**

# Assemblyn kääntäjä ja argumentit (sama avr-gcc)
COMP_AS=avr-gcc
COMPFLAGS_AS=-mmcu=$(MMCU) -Os -c -MMD -MP -I lib -I include/**


# Binäärin pyörittely eri muodoissa (elf -> bin)
BINCOPY=avr-objcopy
BINFLAGS=-g -O binary

# Linkkeri ja linkkeriskripti
LINKER=avr-ld
LINKERSCRIPT=linker.ld
LINKERFLAGS=-T $(LINKERSCRIPT) -m $(TARGET_ARCH) -gc-sections


################################################################################
# Rauta-arkkitehtuuri

# Koodissa kiinnitetyt rekisterit
# (estä C-kääntäjää sörkkimästä, esim. nopeat globaalit muuttujat)
FIXREG :=
ifeq ($(FIXREG),)
COMPFLAGS_C+=$(addprefix -ffixed-,$(FIXREG))
endif

# Käytettävissä oleva muisti, 4/5 512 tavua, 9/10 1024 tavua
ifeq ($(MMCU),attiny4)
ARCH_SIZE=512
else ifeq ($(MMCU),attiny5)
ARCH_SIZE=512
else
ARCH_SIZE=1024
endif


################################################################################
# Tiedostot

# Lista kaikesta C-lähdekoodista
C_SOURCES := $(wildcard $(KOODIKANSIO)/*.c) $(wildcard $(KOODIKANSIO)/**/*.c)

# Lista assembly-lähdekoodista
# Jos toteutus molemmilla kielillä, Käytetään oletuksena C-toteutusta.
# Filtteröidään siis assembly-listasta pois duppelit.
S_SOURCES := $(wildcard $(KOODIKANSIO)/*.S) $(wildcard $(KOODIKANSIO)/**/*.S)
S_SOURCES := $(filter-out $(C_SOURCES:%.c=%.S),$(S_SOURCES))

# Aseta manuaalisesti nimenomaan assembly-versio käytettäväksi
#S_FIXED := src/main.S

ifneq ($(S_FIXED),)
# Filtteröi valittujen assembly-toteutusten C-versiot pois
S_SOURCES += $(S_FIXED)
C_SOURCES := $(filter-out $(S_SOURCES:%.S=%.c),$(C_SOURCES))
endif


# Käännetyt versiot
# C:stä käännetyt .c.o ja assemblystä .S.o
C_OBJECTS := $(C_SOURCES:%.c=%.c.o)
S_OBJECTS := $(S_SOURCES:%.S=%.S.o)

# Tiedostojen sisäiset riippuvuudet
INT_DEPS_C := $(patsubst %.c.o,%.c.dep,$(C_OBJECTS))
INT_DEPS_S := $(patsubst %.S.o,%.S.dep,$(S_OBJECTS))
INT_DEPS := $(INT_DEPS_C) $(INT_DEPS_S)


################################################################################
# Päätargetit

all: $(KOHDEKANSIO) $(KOHDEBIN) show Makefile
build: all


# Näytä disassembly ja statsit
show:
	@echo 
	@test -f $(KOHDE_ELF) && (echo; echo ELF; avr-objdump -D -s $(KOHDE_ELF))
	@test -f $(KOHDEBIN) && (echo; stat -c %.19y $(KOHDEBIN); echo BIN $(KOHDEBIN); od -A x -w16 --endian=big -t x1 $(KOHDEBIN))
	@echo; stat -c "%s/$(ARCH_SIZE) tavua" $(KOHDEBIN)


# Lähetä avrdudella laitteelle
send: $(KOHDEBIN)
	@echo 
	avrdude -c usbtiny -p $(MMCU) -n -U signature:r:/dev/null
	avrdude -c usbtiny -p $(MMCU) -U flash:w:$(KOHDEBIN):a


################################################################################
# Aputargetit


# Build-kansion luonti jos uupuu
$(KOHDEKANSIO):
	@mkdir $(KOHDEKANSIO)


# Poista väliaikatiedostot .o ja .elf
clean:
	@echo
	@echo "Siivotaan $(KOODIKANSIO)"
	@rm -f $(KOODIKANSIO)/*.o
	@rm -f $(KOODIKANSIO)/**/*.o
	@rm -f $(KOODIKANSIO)/*.dep
	@rm -f $(KOODIKANSIO)/**/*.dep
	@echo
	@echo "Siivotaan $(KOHDEKANSIO)"
	@rm -f $(KOHDEKANSIO)/*.elf


# Poista kaikki kohdekansion sisältä ja siivotaan koodikansio
clear: $(KOHDEKANSIO) clean
ifneq ("$(wildcard $(KOHDEKANSIO)/*)","")
	@echo 
	@echo Tyhjätään $(KOHDEKANSIO)
	rm $(wildcard $(KOHDEKANSIO)/*)
else
	@echo 
	@echo $(KOHDEKANSIO) on jo tyhjä
endif


# Listaa tiedostot (Makefile itsensä debuggaukseen)
list:
	@echo 
	@echo C_SOURCES $(C_SOURCES)
	@echo C_OBJECTS $(C_OBJECTS)
	@echo S_SOURCES $(S_SOURCES)
	@echo S_OBJECTS $(S_OBJECTS)
	@echo O_OBJECTS_FROM_C $(O_OBJECTS_FROM_C)
	@echo O_OBJECTS_FROM_S $(O_OBJECTS_FROM_S)
	@echo INT_DEPS $(INT_DEPS)


################################################################################
# Koodin kääntö ja linkkaustargetit


# Binäärin muodostus elffistä kopiointiohjelmalla
$(KOHDEBIN): $(KOHDE_ELF) Makefile
	@echo 
	$(BINCOPY) $(BINFLAGS) $(KOHDE_ELF) $(KOHDEBIN)

# Linkkaa .o-tiedostot linkkeriskriptillä elffiksi.
# O_OBJECTS_FROM_C ja O_OBJECTS_FROM_S sovelluskohtaisia.
$(KOHDE_ELF): $(C_OBJECTS) $(S_OBJECTS) $(LIBS) $(LINKERSCRIPT) Makefile
	@echo 
	@echo Link ELF
	@echo O_OBJECTS_FROM_C $(C_OBJECTS)
	@echo O_OBJECTS_FROM_S $(S_OBJECTS)
	$(LINKER) $(LINKERFLAGS) -o $(KOHDE_ELF) $(C_OBJECTS) $(S_OBJECTS) $(LIBS)


# .c.o-tiedostot C-koodista
# Luodaan samalla riippuvuustiedostot .d
%.c.o: %.c
	@echo 
	@echo Luodaan $@ tiedostosta $<
	$(COMP_CC) $(COMPFLAGS_C) -MF $(@:%.c.o=%.c.dep) -o $@ $<
# .S.o-tiedostot assemblykoodista
%.S.o: %.S
	@echo 
	@echo Luodaan $@ tiedostosta $<
	$(COMP_CC) $(COMPFLAGS_C) -MF $(@:%.S.o=%.S.dep) -o $@ $<


# Sisäiset riippuvuudet .d-tiedostoista (headerit ymv)
-include $(INT_DEPS)
