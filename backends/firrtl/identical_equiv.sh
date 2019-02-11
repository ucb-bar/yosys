#!/usr/bin/env bash -x
DUT=${1:?No DUT argument}
shift
files="$@"
TOP=$DUT
yosys -q -p "
      read_verilog $files
      rename $TOP top1
      proc
      memory
      flatten top1
      hierarchy -top top1

      read_verilog $files
      rename $TOP top2
      proc
      memory
      flatten top2

      equiv_make top1 top2 equiv
      hierarchy -top equiv
      clean -purge
      equiv_simple
      equiv_induct
      equiv_status -assert
    "
