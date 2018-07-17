#!/bin/sh

#  generateVersion.sh
#  yosys-xc
#
#  Created by Jim Lawson on 7/16/18.
#  Copyright © 2018 Jim Lawson. All rights reserved.
# Generate the file containing the Yosys version string.
# We assume we're running under Xcode and GIT_REV is a defined build setting.
OUTPUT_DIR=$BUILT_PRODUCTS_DIR/kernel
OUTPUT_FILE=$OUTPUT_DIR/version_$GIT_REV.cc
mkdir -p $OUTPUT_DIR
YOSYS_VER_STR="Yosys 0.7xxx_$GIT_REV"
echo "namespace Yosys { extern const char *yosys_version_str; const char *yosys_version_str=\"$YOSYS_VER_STR\"; }" > $OUTPUT_FILE.new
if cmp -s $OUTPUT_FILE.new $OUTPUT_FILE ; then
:
else
mv $OUTPUT_FILE.new $OUTPUT_FILE
fi
