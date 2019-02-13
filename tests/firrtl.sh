#!/bin/bash
if [[ $# -gt 0 ]]; then
  tests="$@"
else
  tests=tests/simple/*.v
fi

libs=tests/firrtl.inc.v
for f in $tests; do
  obase=$(basename $f .v)
  vvfile=tests/vout/$obase.v.v
  vfirfile=tests/vout/$obase.v.fir
  vfirvfile=tests/vout/$obase.v.fir.v
  log=tests/vout/$obase.log
  ./yosys -p "read_verilog $f; proc; opt; pmuxtree; write_verilog $vvfile" 
  modules=($(gawk -F '(\\s)|(\\()' -e '/^\s*module / { print $2 }' $vvfile))
  if [[ ${#modules[*]} -eq 1 ]]; then
    DUT=${modules[0]}
    echo "$vvfile: $DUT"
    sed -E -i.bak -e '/\.MEMID\(\"/d' -e "/\.CLK\(1'hx\),/s/1'hx/clk/" $vvfile
    prefix=$(basename $vvfile .v)
    ./yosys -v 9 -L $log -p "prep -nordff; hierarchy -top $DUT; pmuxtree; write_firrtl $vfirfile" -f "verilog " $libs $vvfile
    java -cp ~/noArc/clients/ucb/git/ucb-bar/firrtl/utils/bin/firrtl.jar firrtl.Driver -i $vfirfile -o $vfirvfile -X verilog
    backends/firrtl/formal_equiv.sh $DUT $vvfile $vfirvfile
  fi
done
