#!/bin/sh

#  generateSimHelp.sh
#  yosys-xc
#
#  Created by Jim Lawson on 7/16/18.
#  Copyright © 2018 Jim Lawson. All rights reserved.
# Generate the file containing the sim help.
# We assume we're running under Xcode.
PYTHON_PROG=$1
PYTHON_DATA=$2
OUTPUT_FILE=$3
mkdir -p "$(dirname -- "$OUTPUT_FILE")"
/opt/local/bin/python3 $PYTHON_PROG $PYTHON_DATA > $OUTPUT_FILE.new
mv $OUTPUT_FILE.new $OUTPUT_FILE
