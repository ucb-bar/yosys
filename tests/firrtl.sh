#!/bin/bash
if [[ $# -gt 0 ]]; then
  tests="$@"
else
  tests=tests/simple/*.v
fi

for f in $tests; do
  modules=($(gawk -F '(\\s)|(\\()' -e '/^\s*module / { print $2 }' $f))
  if [[ ${#modules[*]} -eq 1 ]]; then
    DUT=${modules[0]}
    echo "$f: $DUT"
    prefix=$(basename $f .v)
    dir=$(echo $f | sed -e 's/\.v$/.out/')
    args="testbench $dir/${prefix}_tb.v $dir/${prefix}_syn0.v"
    backends/firrtl/identical_equiv.sh $args
  fi
done
