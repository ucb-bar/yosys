#!/usr/bin/env bash
if [[ ${#@} -lt 3 ]]; then
  echo "$0: need DUT f1 f2"
  exit 1
fi
DUT=${1:?No DUT argument}
shift
t1="$1"
t2="$2"
yosys -q -p "
      read_verilog $t1
      rename $DUT top1
      proc
      memory
      flatten top1
      hierarchy -top top1

      read_verilog $t2
      rename $DUT top2
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
