vlib work
vlog Wrapper.v Wrapper_tb.v
vsim -voptargs=+acc work.Wrapper_tb
add wave *
run -all
#quit -sim