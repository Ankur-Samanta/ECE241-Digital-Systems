# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part2.v

#load simulation using mux as the top level simulation module
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# test case
#set input values using the force command, signal names need to be in {} brackets

force ClockIn 0 0ns, 1 {1ns} -r 2ns


# starting point
force Reset 0
force Speed 01
run 100 ns


# reset
force Reset 1
force Speed 01
run 100 ns

# run for 500+ clock cycles
force Reset 0
force Speed 01
run 1000 ns

# run for 500+ clock cycles
force Reset 0
force Speed 01
run 1000 ns

# run for 1000+ clock cycles
force Reset 0
force Speed 10
run 2000 ns

# reset
force Reset 1
force Speed 11
run 100 ns

# run for 2000+ clock cycles
force Reset 0
force Speed 11
run 4200 ns