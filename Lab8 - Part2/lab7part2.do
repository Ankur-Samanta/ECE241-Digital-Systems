vlib work
vlog part2.v
vsim part2
log {/*}
add wave {/*}

force iClock 0 0ns, 1 {5ns} -r 10ns

# starting point
force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b000
force {iXY_Coord} 7'b0000011
run 20 ns

# pulse reset (low)
force {iResetn} 1'b0
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b000
force {iXY_Coord} 7'b0000011
run 20 ns

# pulse reset (high)
force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b000
force {iXY_Coord} 7'b0000011
run 20 ns

# load x
force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b1
force {iColour} 3'b000
force {iXY_Coord} 7'b0000011
run 20 ns

force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b000
force {iXY_Coord} 7'b0000011
run 20 ns

# load y
force {iResetn} 1'b1
force {iPlotBox} 1'b1
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b101
force {iXY_Coord} 7'b0000000
run 20 ns

force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b101
force {iXY_Coord} 7'b0000000
run  240 ns


# RUN 2
# pulse reset (low)
force {iResetn} 1'b0
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b010
force {iXY_Coord} 7'b0110101
run 20 ns

# pulse reset (high)
force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b010
force {iXY_Coord} 7'b0110101
run 20 ns

# load x
force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b1
force {iColour} 3'b010
force {iXY_Coord} 7'b0110101
run 20 ns

force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b010
force {iXY_Coord} 7'b0110101
run 20 ns

# load y
force {iResetn} 1'b1
force {iPlotBox} 1'b1
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b010
force {iXY_Coord} 7'b0001001
run 20 ns

force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b0
force {iLoadX} 1'b0
force {iColour} 3'b010
force {iXY_Coord} 7'b0001001
run  240 ns

#blackout
force {iResetn} 1'b1
force {iPlotBox} 1'b0
force {iBlack} 1'b1
force {iLoadX} 1'b0
force {iColour} 3'b010
force {iXY_Coord} 7'b0001001
run  240 ns
