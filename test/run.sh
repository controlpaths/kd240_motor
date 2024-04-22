
iverilog ../test/openloop_tb.v ../src/angle_gen.v ../src/modulator_pwm_gain.v ../src/three_phase_modulator.v ../src/dq2abc.v -s openloop_tb -o ./sim.vvp
vvp sim.vvp
rm ./sim.vvp