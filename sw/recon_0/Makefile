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
BOARD_NAME    = bemicro_max10
#You need "find" command in your search path. Windows system may have some difficulty. 
#Here we search in hardware directories for the SOF files and with the correct BOARD_NAME
#Then select between released sof file and development sof file
SOF_FILES     = $(shell find $(HARDWARE_PATH) | grep -G sof$)
REL_SOF_FILE  = $(shell find $(HARDWARE_PATH) | grep -G sof$ | grep $(BOARD_NAME)/release)
DEV_SOF_FILE  = $(shell find $(HARDWARE_PATH) | grep -G sof$ | grep $(BOARD_NAME))
SOF_FILE      = $(if $(REL_SOF_FILE),$(REL_SOF_FILE),${DEV_SOF_FILE})

#These commands are available in NIOS2-Command-Shell
CREATE_BSP = nios2-bsp
EDIT_BSP   = nios2-bsp-editor
CREATE_LIB = nios2-lib-generate-makefile
CREATE_APP = nios2-app-generate-makefile

BSP_DIR    = ./bsp
LIB_DIR    = lib_$(PLATFORM_NAME)
APP_NAME   = new_app
EX_NAME    = frequency_counter

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

.phony : bsp
bsp : generate_bsp

.phony : generate_bsp 
generate_bsp: ##Generate or Update BSP. Always use HAL. Ouput to "bsp" directory. SOPC file is fetched from the hardware
	$(CREATE_BSP) hal $(BSP_DIR) $(HARDWARE_PATH)/$(PLATFORM_NAME).sopcinfo 

.phony : edit_bsp 
edit_bsp: ##Open the GUI that we can edit the BSP settings. Remember to Save and then Generate it.
	-mkdir $(BSP_DIR)/edit_dir
	cd $(BSP_DIR) && $(EDIT_BSP) --settings settings.bsp

.phony : generate_lib
generate_lib: ##Generate library that contains drivers of our custom hardware (not from Altera).
	$(CREATE_LIB) --bsp-dir=$(BSP_DIR) --inc-dir=$(ROOT)/sw/cmn/util --src-rdir=$(ROOT)/sw/cmn --lib-dir=$(LIB_DIR) --lib-name=$(PLATFORM_NAME)

.phony : generate_app
generate_app: ##Generate a new app. Default APP_NAME=new_app. Overwrite it with make generate_app APP_NAME=<your app name>.
	mkdir $(APP_NAME)
	mkdir $(APP_NAME)/src
	cp $(ROOT)/sw/cmn/util/main_template $(APP_NAME)/src/main.cpp
	cp $(ROOT)/sw/cmn/util/app_template $(APP_NAME)/src/app.cpp
	$(CREATE_APP) --bsp-dir=$(BSP_DIR) --inc-rdir=$(ROOT)/sw/cmn --app-dir=./$(APP_NAME) --elf-name=$(APP_NAME).elf --src-dir=$(APP_NAME)/src --use-lib-dir=lib_$(PLATFORM_NAME)

.phony : app
app : ##Build and generate memory initialization file for $(APP_NAME) 
	make -C $(APP_NAME) mem_init_generate

.phony : generate_example
generate_example : ##Create an example to run with current platform from the example collection, example $(EX_NAME) is created
	#Copy the example to the local directory 
	#cp  -r ../examples/$(EX_NAME) ./
	mkdir $(EX_NAME)
	$(CREATE_APP) --bsp-dir=$(BSP_DIR) --inc-rdir=$(ROOT)/sw/cmn --app-dir=./$(EX_NAME) --elf-name=$(EX_NAME).elf --src-dir=$(ROOT)/sw/examples/$(EX_NAME)/src --use-lib-dir=lib_$(PLATFORM_NAME)
	


.phony : pof
pof : generate_pof

.phony : generate_pof
generate_pof: ##Generate POF file from SOF file and memory initialization file
	quartus_cpf -c -o compression=on -o ufm_source_file=$(APP_NAME)/mem_init/onchip_flash.hex $(SOF_FILE) ./$(PLATFORM_NAME)_$(BOARD_NAME).pof


.phony : clean
clean : ##Clean BSP, LIB and APP folder 
	make clean -C $(BSP_DIR)
	make clean -C $(APP_NAME)
	make clean -C $(LIB_DIR)

.phony: reset
reset : ##Remove BSP and LIB folder
	-find $(BSP_DIR) ! -name settings.bsp -delete
	rm -rf $(LIB_DIR)

#You can use this phony target to test your modified Makefile
#I find the way Makefile parses the Makefile is rather confusing and unlike other programmes
#So a test target is quite helpful to do experiment and debug
.phony : test 

test : ##Test target 
	@echo Current platform is $(PLATFORM_NAME)
