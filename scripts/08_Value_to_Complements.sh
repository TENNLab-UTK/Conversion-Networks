# This creates a network to convert values to their complements in all three encodings.
# We then applies a value to it.  It prints the "RSC" output for max+3 timesteps.

if [ $# -ne 3 ]; then
  echo 'usage: sh scripts/08_Value_to_Complements.sh M V os_framework - use -1 for V to not run' >&2
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
  echo AN 0 1 2 3 4
  echo AI 0 1
  echo AO 0 3 4
  echo SETNAME 0 C_time
  echo SETNAME 1 S
  echo SETNAME 2 D
  echo SETNAME 3 C_train
  echo SETNAME 4 C_value
  echo SNP_ALL Threshold 1
  echo SNP 0 Threshold $mp1
  echo SNP 4 Threshold $mp1

  echo AE 0 0  0 2
  echo AE 1 0  1 2  1 3  1 4
  echo AE 2 0  2 2  2 3  2 4

  echo SEP_ALL Weight 1
  echo SEP_ALL Delay 1
  echo SEP 0 0 Weight -1
  echo SEP 0 2 Weight -1
  echo SEP 1 3 Weight -1
  echo SEP 1 4 Weight -1
  
  echo SORT Q
  echo TJ tmp_network.txt
  
  ) | $fro/bin/network_tool

if [ $v = -1 ]; then exit 0; fi

( echo ML tmp_network.txt
  echo ASV 0 0 $v
  echo AS 1 0 1
  echo RSC $(($m+3))
) > tmp_pt_input.txt

$fro/bin/processor_tool_risp < tmp_pt_input.txt

