transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/ExtremeTech/Documents/GitHub/ComputerArchitecture2.Project2 {C:/Users/ExtremeTech/Documents/GitHub/ComputerArchitecture2.Project2/alu_6lanes.sv}
vlog -sv -work work +incdir+C:/Users/ExtremeTech/Documents/GitHub/ComputerArchitecture2.Project2 {C:/Users/ExtremeTech/Documents/GitHub/ComputerArchitecture2.Project2/alu_tb.sv}

