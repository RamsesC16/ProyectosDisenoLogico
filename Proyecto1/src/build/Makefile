# ==== Configuración general ====
BOARD  = tangnano9k
FAMILY = GW1N-9C
DEVICE = GW1NR-LV9QN88PC6/I5

# Directorios
SRC_DIR = ../src
SIM_DIR = ../sim
CONSTR_DIR = ../constr

# Fuentes del proyecto
SOURCES := $(wildcard $(SRC_DIR)/*.sv)

# ==== Configuración de síntesis (FPGA) ====
TOP_DESIGN = modulo_top
CONSTRAINTS = $(CONSTR_DIR)/proyecto1.cst
PROYECT = proyecto1

# ==== Targets de simulación ====

# Codificador
sim_codi: $(SRC_DIR)/modulo_codificador.sv $(SIM_DIR)/module_codi_tb.sv
	iverilog -o sim_codi.o -s module_codi_tb -g2005-sv $^
	vvp sim_codi.o
	gtkwave module_codi_tb.vcd &

# Decodificador
sim_decodi: $(SRC_DIR)/module_decodi.sv $(SIM_DIR)/module_decodi_tb.sv
	iverilog -o sim_decodi.o -s module_decodi_tb -g2005-sv $^
	vvp sim_decodi.o
	gtkwave module_decodi_tb.vcd &

# Detector
sim_detector: $(SRC_DIR)/modulo_detector_error.sv $(SIM_DIR)/module_detector_error_tb.sv
	iverilog -o sim_detector.o -s module_detector_error_tb -g2005-sv $^
	vvp sim_detector.o
	gtkwave module_detector_error_tb.vcd &

# Corrector
sim_corrector: $(SRC_DIR)/modulo_corrector_error.sv $(SIM_DIR)/module_corrector_error_tb.sv
	iverilog -o sim_corrector.o -s module_corrector_error_tb -g2005-sv $^
	vvp sim_corrector.o
	gtkwave module_corrector_error_tb.vcd &

# LEDs
sim_led: $(SRC_DIR)/module_led.sv $(SIM_DIR)/module_led_tb.sv
	iverilog -o sim_led.o -s module_led_tb -g2005-sv $^
	vvp sim_led.o
	gtkwave module_led_tb.vcd &

# Display 7 segmentos
sim_display: $(SRC_DIR)/module_7segmentos.sv $(SIM_DIR)/module_7segmentos_tb.sv
	iverilog -o sim_display.o -s module_7segmentos_tb -g2005-sv $^
	vvp sim_display.o
	gtkwave module_7segmentos_tb.vcd &

# Display error
sim_disp_error: $(SRC_DIR)/module_display_error.sv $(SIM_DIR)/module_display_error_tb.sv
	iverilog -o sim_disp_error.o -s module_display_error_tb -g2005-sv $^
	vvp sim_disp_error.o
	gtkwave module_display_error_tb.vcd &

# Sistema completo (top)
sim_top: $(SOURCES) $(SIM_DIR)/modulo_top_tb.sv
	iverilog -o sim_top.o -s modulo_top_tb -g2005-sv $^
	vvp sim_top.o
	gtkwave modulo_top_tb.vcd &

# ==== Flujo FPGA ====
all: synth pnr bitstream

synth: $(SOURCES)
	yosys -p "read_verilog -sv $(SOURCES); synth_gowin -top $(TOP_DESIGN) -json $(PROYECT).json" > synthesis.log 2>&1

pnr: $(PROYECT).json
	nextpnr-gowin --json $(PROYECT).json --write $(PROYECT)_pnr.json --freq 27 --device $(DEVICE) --family $(FAMILY) --cst $(CONSTRAINTS) > pnr.log 2>&1

bitstream: $(PROYECT)_pnr.json
	gowin_pack -d $(FAMILY) -o $(PROYECT)_$(BOARD).fs $(PROYECT)_pnr.json

load: $(PROYECT)_$(BOARD).fs
	openFPGALoader -b $(BOARD) $(PROYECT)_$(BOARD).fs

clean:
	rm -f *.o *.vcd *.json *_pnr.json *.fs