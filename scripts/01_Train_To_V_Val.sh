# This creates a network that converts a spike train to a value stored in the 
# potential of an input neuron.

if [ $# -ne 3 ]; then
  echo 'usage: sh scripts/01_Train_To_V_Val.sh.sh M V framework_open_dir  - use -1 for V to not run' >&2
  exit 1
fi

m=$1
v=$2
fro=$3

for i in network_tool processor_tool_risp ; do
  if [ ! -x $fro/bin/$i ]; then
    ( cd $fro ; make bin/$i )
  fi
done

mp1=$(($m+1))

# Make an empty network with the proper RISP parameters.

cat $fro/params/risp_127.txt | sed 's/127/'$mp1'/g' > tmp_risp.txt

( echo M risp tmp_risp.txt
  echo EMPTYNET tmp_emptynet.txt ) | $fro/bin/processor_tool_risp

# Now create the network and put it into tmp_network.txt

( echo FJ tmp_emptynet.txt
  echo AN 0
  echo AI 0
  echo AO 0
  echo SETNAME 0 V_value
  echo SNP 0 Threshold $mp1

  echo SORT Q
  echo TJ tmp_network.txt
  
  ) | $fro/bin/network_tool

# Exit if the value is -1

if [ $v = -1 ]; then exit 0; fi

# Create input for the processor tool

( echo ML tmp_network.txt
  i=0
  while [ $i -lt $v ]; do
    echo ASV 0 $i 1
    i=$(($i+1))
  done
  echo RSC $(($m))
) > tmp_pt_input.txt

# Run the processor tool

$fro/bin/processor_tool_risp < tmp_pt_input.txt

