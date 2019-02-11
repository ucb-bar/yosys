#!/bin/bash
if [[ $# -gt 0 ]]; then
  tests="$@"
else
  tests=tests/simple/*.v
fi

for f in $tests; do
  obase=$(basename $f .v)
  ofile=tests/vout/$obase.v.v
  ofir=tests/vout/$obase.v.fir
  ofirv=tests/vout/$obase.v.fir.v
  log=tests/vout/$obase.log
  ./yosys -p "read_verilog $f; proc; opt; pmuxtree; write_verilog $ofile" 
  modules=($(gawk -F '(\\s)|(\\()' -e '/^\s*module / { print $2 }' $ofile))
  if [[ ${#modules[*]} -eq 1 ]]; then
    DUT=${modules[0]}
    echo "$ofile: $DUT"
    prefix=$(basename $ofile .v)
    ./yosys -v 9 -L $log -p "prep -nordff; hierarchy -top $DUT; pmuxtree; write_firrtl $ofir" -f "verilog " $ofile
    java -cp ~/noArc/clients/ucb/git/ucb-bar/firrtl/utils/bin/firrtl.jar firrtl.Driver -i $ofir -o $ofirv -X verilog
    backends/firrtl/formal_equiv.sh $DUT $ofile $ofirv
  fi
done
