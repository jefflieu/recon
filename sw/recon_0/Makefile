# Project 	: RECON 2017
# Author 		: Jeff Lieu <lieumychuong@gmail.com>
# Note that you need to be in NIOS2 Command Line Shell to run this Makefile
#
ROOT 					= ../..
SOFTWARE_PATH = $(shell pwd)
HARDWARE_PATH = $(subst sw,hw,$(SOFTWARE_PATH))
PLATFORM_NAME = $(lastword $(subst /, ,$(SOFTWARE_PATH)))

CREATE_BSP = nios2-bsp
EDIT_BSP   = nios2-bsp-editor
CREATE_LIB = nios2-lib-generate-makefile
CREATE_APP = nios2-app-generate-makefile

BSP_DIR = ./bsp

APP_NAME  = new_app

.phony : generate_bsp
generate_bsp:
	$(CREATE_BSP) hal $(BSP_DIR) $(HARDWARE_PATH)/$(PLATFORM_NAME).sopcinfo 

.phony : edit_bsp 
edit_bsp:
	-mkdir $(BSP_DIR)/edit_dir
	cd $(BSP_DIR)/edit_dir && $(EDIT_BSP) --settings ../settings.bsp

.phony : generate_lib
generate_lib: 
	$(CREATE_LIB) --bsp-dir=$(BSP_DIR) --inc-dir=$(ROOT)/sw/cmn/util --src-rdir=$(ROOT)/sw/cmn --lib-dir=lib_$(PLATFORM_NAME) --lib-name=$(PLATFORM_NAME)

.phony : generate_app
generate_app: 
	mkdir $(APP_NAME)
	mkdir $(APP_NAME)/src
	cp $(ROOT)/sw/cmn/util/main_template $(APP_NAME)/src/main.cpp
	cp $(ROOT)/sw/cmn/util/app_template $(APP_NAME)/src/app.cpp
	$(CREATE_APP) --bsp-dir=$(BSP_DIR) --inc-rdir=$(ROOT)/sw/cmn --app-dir=./$(APP_NAME) --elf-name=$(APP_NAME) --src-dir=$(APP_NAME)/src --use-lib-dir=lib_$(PLATFORM_NAME)

.phony : test 

test : 
	echo $(PLATFORM_NAME)
