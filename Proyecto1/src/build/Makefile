# ==== Configuración general ====
BOARD  = tangnano9k
FAMILY = GW1N-9C
DEVICE = GW1NR-LV9QN88PC6/I5

# ==== Nombre del proyecto ====
PROYECT = Proyecto1

# ==== Directorios ====
SRC_DIR    = ../design
SIM_DIR    = ../sim
CONSTR_DIR = ../constr

# ==== Fuentes de diseño ====
SOURCES := $(wildcard $(SRC_DIR)/*.v $(SRC_DIR)/*.sv)

# ==== Fuente de simulación ====
# (Se sobrescribe desde la terminal con: make test TESTBENCH=../sim/module_codi_tb.sv TOP_TB=module_codi_tb VCD_FILE=module_codi_tb.vcd)
TESTBENCH ?= ../sim/module_top_tb.sv
TOP_TB    ?= module_top_tb
VCD_FILE  ?= module_top_tb.vcd

# ==== Constraints ====
CONSTRAINTS = $(CONSTR_DIR)/module_constraints.cst

# ==== Top design (nombre del módulo superior) ====
TOP_DESIGN = module_top

# ==== Targets principales ====
all: synth pnr bitstream load

# Síntesis
synth: ${SOURCES}
	@echo "Ejecutando síntesis..."
	@yosys -p "read_verilog -sv ${SOURCES}; synth_gowin -top ${TOP_DESIGN} -json ${PROYECT}.json" > synthesis_${BOARD}.log 2>&1
	@echo "COMPLETADO"

# Place & Route
pnr: ${PROYECT}.json
	@echo "Ejecutando PnR..."
	@nextpnr-gowin --json ${PROYECT}.json --write ${PROYECT}_pnr.json --freq 27 --device ${DEVICE} --family ${FAMILY} --cst ${CONSTRAINTS} > pnr_${BOARD}.log 2>&1
	@echo "COMPLETADO"

# Bitstream
bitstream: ${PROYECT}_pnr.json
	@echo "Generando ${PROYECT}_${BOARD}.fs"
	@gowin_pack -d ${FAMILY} -o ${PROYECT}_${BOARD}.fs ${PROYECT}_pnr.json
	@echo "COMPLETADO"

# ==== Simulación ====
test: ${SOURCES} ${TESTBENCH}
	@iverilog -o ${PROYECT}_test.o -s ${TOP_TB} -g2005-sv ${TESTBENCH} ${SOURCES}
	@vvp ${PROYECT}_test.o

wv: ${VCD_FILE}
	gtkwave ${VCD_FILE}

# ==== Cargar en la FPGA ====
load: ${PROYECT}_${BOARD}.fs
	openFPGALoader -b ${BOARD} ${PROYECT}_${BOARD}.fs

# ==== Limpieza ====
clean:
	rm -f *.o *.vcd *.json *_pnr.json *.fs

.PHONY: load wv clean
.INTERMEDIATE: ${PROYECT}_pnr.json ${PROYECT}.json