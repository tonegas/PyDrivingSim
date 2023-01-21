#
# Authors: Alessandro Mazzalai, Gastone Pietro Rosati Papini and Riccardo Donà
#
# Use "make all" to build the interfaces for the co-driver
#
# Important: In "data" directory there must be only ONE csv file saved from an excel file. Other unused csv files must be removed.
# The interface files are generated in the "out" folder
#

# Settings --------------------------------
# Base name
BASE_NAME = interfaces
# -----------------------------------------



$(info ========================== Interfaces ==========================)

# Check OS
OS = $(shell uname)

ifeq ($(OS), Darwin)
$(info OS detected -> MAC OS X)
else ifeq ($(OS), Linux)
$(info OS detected -> LINUX)
else
$(error OS detected $(OS) is NOT SUPPORTED)
endif

# Check csv file from "data" directory
DATA_DIR = ../data
DATA_CSV = $(wildcard $(DATA_DIR)/$(BASE_NAME)_*.csv)

ifneq ("$(DATA_CSV)","")
$(info Interface file -> $(DATA_CSV))
else
$(error Interface file not found! Create a csv file in "$(DATA_DIR)" directory)
endif

$(info ================================================================)


TMP_DIR = ../tmp
OUT_DIR = ../out
OUT_DIR_MATHEMATICA = $(OUT_DIR)/mathematica_interfaces
OUT_DIR_JAVA = $(OUT_DIR)/java_interfaces
OUT_DIR_MICROAUTOBOX = $(OUT_DIR)/microautobox_interfaces
OUT_DIR_STRUCT_PRINTER = $(OUT_DIR)/struct_printer_functions


all:
	ruby csv_importer.rb $(DATA_CSV) $(BASE_NAME) $(TMP_DIR)
	ruby interfaces_generator.rb $(BASE_NAME) $(TMP_DIR) $(OUT_DIR)

clean:
	-rm $(TMP_DIR)/*
	-rm -rf $(OUT_DIR)/*
