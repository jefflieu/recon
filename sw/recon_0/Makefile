# Project 	: RECON 2017
# Author 		: Jeff Lieu <lieumychuong@gmail.com>
# Note that you need to be in NIOS2 Command Line Shell to run this Makefile
# This Makefile simplies the process of developing software for FPGA based embedded system
# Type make help for more information 

#Directory hierarchy: 
#recon --> hw --> cmn
#							    ---> io
#							    ---> timer
#							    ---> util
#             --> recon_0           	: 
#									---> bemicro_max10	: board specific settings 
# An equivalent hierarchy in software branch
#recon --> sw --> cmn 
#             --> recon_0
#                 ---> bsp 
#                 ---> lib_recon_0
#                 ---> <your apps here>, your app can run on the same platform with any board, because the NIOS system is the same

ROOT          = ../..
SOFTWARE_PATH = $(shell pwd)
HARDWARE_PATH = $(subst sw,hw,$(SOFTWARE_PATH))
PLATFORM_NAME = $(lastword $(subst /, ,$(SOFTWARE_PATH)))

#These commands are available in NIOS2-Command-Shell
CREATE_BSP = nios2-bsp
EDIT_BSP   = nios2-bsp-editor
CREATE_LIB = nios2-lib-generate-makefile
CREATE_APP = nios2-app-generate-makefile

BSP_DIR    = ./bsp

APP_NAME   = new_app
.phony : help 
help : #Fancy auto help
		@IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
    for help_line in $${help_lines[@]}; do \
        IFS=$$'#' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf "%-30s %s\n" $$help_command $$help_info ; \
    done

.phony : generate_bsp 
generate_bsp: ##Generate or Update BSP. Always use HAL. Ouput to "bsp" directory. SOPC file is fetched from the hardware
	$(CREATE_BSP) hal $(BSP_DIR) $(HARDWARE_PATH)/$(PLATFORM_NAME).sopcinfo 

.phony : edit_bsp 
edit_bsp: ##Open the GUI that we can edit the BSP settings. Remember to Save and then Generate it.
	-mkdir $(BSP_DIR)/edit_dir
	cd $(BSP_DIR)/edit_dir && $(EDIT_BSP) --settings ../settings.bsp

.phony : generate_lib
generate_lib: ##Generate library that contains drivers of our custom hardware (not from Altera).
	$(CREATE_LIB) --bsp-dir=$(BSP_DIR) --inc-dir=$(ROOT)/sw/cmn/util --src-rdir=$(ROOT)/sw/cmn --lib-dir=lib_$(PLATFORM_NAME) --lib-name=$(PLATFORM_NAME)

.phony : generate_app
generate_app: ##Generate a new app. Default APP_NAME=new_app. Overwrite it with make generate_app APP_NAME=<your app name>.
	mkdir $(APP_NAME)
	mkdir $(APP_NAME)/src
	cp $(ROOT)/sw/cmn/util/main_template $(APP_NAME)/src/main.cpp
	cp $(ROOT)/sw/cmn/util/app_template $(APP_NAME)/src/app.cpp
	$(CREATE_APP) --bsp-dir=$(BSP_DIR) --inc-rdir=$(ROOT)/sw/cmn --app-dir=./$(APP_NAME) --elf-name=$(APP_NAME).elf --src-dir=$(APP_NAME)/src --use-lib-dir=lib_$(PLATFORM_NAME)

#You can use this phony target to test your modified Makefile
#I find the way Makefile parses the Makefile is rather confusing and unlike other programmes
#So a test target is quite helpful to do experiment and debug
.phony : test 

test : #Test target 
	@echo Current platform is $(PLATFORM_NAME)
