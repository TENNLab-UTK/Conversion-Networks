# This creates a network that converts values to their complements in all three
# encodings, and then applies a value to it.  It prints
# the "RSC" output for 2M+3 timesteps.

if [ $# -ne 3 ]; then
  echo 'usage: sh scripts/06_Time_to_Complements.sh M V os_framework - use -1 for V to not run' >&2
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
mp3=$(($m+3))

# Make an empty network with the proper RISP parameters.

cat $fro/params/risp_127.txt | sed 's/127/'$mp1'/g' > tmp_risp.txt

( echo M risp tmp_risp.txt
  echo EMPTYNET tmp_emptynet.txt ) | $fro/bin/processor_tool_risp

# Now create the network and put it into tmp_network.txt

( echo FJ tmp_emptynet.txt
  echo AN 0 1 2 3 4 5 6
  echo AI 0 1
  echo AO 2 3 5
  echo SETNAME 0 B
  echo SETNAME 1 S
  echo SETNAME 2 C_train
  echo SETNAME 3 C_value
  echo SETNAME 4 V_train
  echo SETNAME 5 C_time
  echo SETNAME 6 G
  echo SNP_ALL Threshold 1
  echo SNP 3 Threshold $mp1
  echo SNP 5 Threshold $m

  echo AE 0 4
  echo AE 1 2   1 3    1 4   1 6
  echo AE 4 4   4 5
  echo AE 5 5   5 6  
  echo AE 6 5   6 6   6 2  6 3

  echo SEP_ALL Weight 1
  echo SEP_ALL Delay 1
  echo SEP 0 4 Weight -1
  echo SEP 1 2 Weight -1
  echo SEP 1 3 Weight -1
  echo SEP 1 6 Delay $mp1
  echo SEP 5 5 Weight -1
  echo SEP 5 6 Weight -1
  
  echo SORT Q
  echo TJ tmp_network.txt
  
  ) | $fro/bin/network_tool

if [ $v = -1 ]; then exit 0; fi

( echo ML tmp_network.txt
  echo AS 0 $v 1
  echo AS 1 0 1
  echo RSC $(($m+$m+3))
) > tmp_pt_input.txt

$fro/bin/processor_tool_risp < tmp_pt_input.txt

