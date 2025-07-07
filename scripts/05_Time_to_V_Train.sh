# This creates a network that converts timings to spike trains and values.
# It then runs it and shows the "RSC" output for max+2 timesteps.

if [ $# -ne 3 ]; then
  echo 'usage: sh scripts/05_Time_to_V_Train.sh M V os_framework - use -1 for V to not run' >&2
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
mp2=$(($m+2))

# Make an empty network with the proper RISP parameters.

cat $fro/params/risp_127.txt | sed 's/127/'$mp1'/g' > tmp_risp.txt

( echo M risp tmp_risp.txt
  echo EMPTYNET tmp_emptynet.txt ) | $fro/bin/processor_tool_risp

# Now create the network and put it into tmp_network.txt

( echo FJ tmp_emptynet.txt
  echo AN 0 1 2 3
  echo AI 0 1
  echo AO 2 3
  echo SETNAME 0 B
  echo SETNAME 1 S
  echo SETNAME 2 V_train
  echo SETNAME 3 V_value
  echo SNP_ALL Threshold 1
  echo SNP 3 Threshold $mp1

  echo AE 0 2
  echo AE 1 2 
  echo AE 2 2   2 3

  echo SEP_ALL Weight 1
  echo SEP_ALL Delay 1
  echo SEP 0 2 Weight -1
  
  echo SORT Q
  echo TJ tmp_network.txt
  
  ) | $fro/bin/network_tool

if [ $v = -1 ]; then exit 0; fi

# Create the processor tool commands that applies a spike at the appropriate time,
# and another spike at time 0 to the S neuron.  It runs for m+3 timesteps.

( echo ML tmp_network.txt
  echo AS 0 $v 1
  echo AS 1 0 1
  echo RSC $(($m+2))
) > tmp_pt_input.txt

$fro/bin/processor_tool_risp < tmp_pt_input.txt

