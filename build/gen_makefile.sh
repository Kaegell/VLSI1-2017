#!/bin/bash

src="../src/"
bin="../bin/"
destfile="makefile"

# ------------- The big function -----------------------------------------------
# This function adds .o and _tb dependencies for the given vhdl file
function add_entity {
    echo "Calling add_obj_target() with $file";
    arg=$1;
    target_filename=${arg%.*};
    target="$target_filename.o";
    target_dir=$(dirname $1);

    # Find object file dependencies
    dependencies=`ls -lL $target_dir | grep '^[dl]' | awk '{print $9}' |
    sed -e "s:^\(.*\)$:$target_dir/\1/\1.o\\\\\:g"`;

    # Add VHDL source to dependencies
    if [ "$dependencies" == "" ]; then
        dependencies="$target_filename.vhdl";
    else
        dependencies="$dependencies\\\n$target_filename.vhdl";
    fi

    # Command
    commands="ghdl -a -v $target_filename.vhdl"

    # Writing to makefile
    echo -e "#Entity $(basename $target_filename)" >> $destfile
    echo -e "$target: $dependencies" >> $destfile
    echo -e "\t$commands" >> $destfile
    echo "" >> $destfile
    echo -e "${target_filename}_tb : ${target} ${target_filename}_tb.vhdl" >> $destfile
    echo -e "\tghdl -a -v ${target_filename}_tb.vhdl" >> $destfile
    echo -e "\tghdl -e -v $(basename $target_filename)_tb" >> $destfile
    echo -e "\tmv $(basename $target_filename)_tb $bin" >> $destfile
    echo "" >> $destfile
    echo "" >> $destfile
}

# ----------- Check arguments --------------------------------------------------
if [ "$src" == "" ]; then
    echo "[Error] Variable src has not been defined, modify me"
    exit;
fi

if [ "$bin" == "" ]; then
    echo "[Error] Variable bin has not been defined, modify me"
    exit;
fi

if [ "$destfile" == "" ]; then
    echo "[Error] Variable destfile has not been defined, modify me"
    exit;
fi

# ---------- Main program ------------------------------------------------------
sources=`find -L $src \\( -iname "*.vhdl" ! -iname "*_tb.vhdl" \\)`
echo $sources;

echo -e "all : main_tb" >> $destfile
echo -e "" >> $destfile

echo "" > $destfile
for file in $sources
do
    add_entity $file
done

# Add "manually" the main_tb to the makefile

echo -e "../src/main_tb/main_tb.o : ../src/main_tb/main_tb.vhdl\\
         ../src/main_tb/arm_core/arm_core.o\\
         ../src/main_tb/icache/icache.o\\
         ../src/main_tb/dcache/dcache.o" >> $destfile
echo -e "\tghdl -a -v main_tb.vhdl" >> $destfile
echo -e >> $destfile

echo -e "main_tb : ../src/main_tb/main_tb.o ../lib/arm_ghdl.o" >> $destfile
echo -e "\tghdl -e -v -Wl,../lib/mem.o -Wl,../lib/arm_ghdl.o -Wl,../lib/ElfObj.o main_tb" >> $destfile
echo -e "" >> $destfile

echo -e "clean:" >> $destfile
echo -e "\trm *.o" >> $destfile
echo -e "\trm *.cf" >> $destfile
echo -e "" >> $destfile

echo -e "mrproper:" >> $destfile
echo -e "\trm -r $bin/*" >> $destfile
echo -e "" >> $destfile

