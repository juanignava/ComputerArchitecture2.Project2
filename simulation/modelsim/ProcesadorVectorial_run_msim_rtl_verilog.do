transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/MySpot/ComputerArchitecture2.Project2 {C:/MySpot/ComputerArchitecture2.Project2/control_unit.sv}
vlog -sv -work work +incdir+C:/MySpot/ComputerArchitecture2.Project2 {C:/MySpot/ComputerArchitecture2.Project2/control_unit_tb.sv}

