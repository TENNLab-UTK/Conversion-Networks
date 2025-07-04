# This creates a V_{train} -> C_{val}, and then applies a value to it using a spike train.  
# It prints the "RSC" output for max+1 timesteps.

if [ $# -ne 3 ]; then
  echo 'usage: sh scripts/02_Train_To_C_Val.sh M V os_framework - use -1 for V to not run' >&2
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
  echo AN 0 1 2
  echo AI 0 1
  echo AO 2
  echo SETNAME 0 A
  echo SETNAME 1 S
  echo SETNAME 2 C_value
  echo SNP_ALL Threshold 1
  echo SNP 2 Threshold $mp1

  echo AE 0 2   1 2
  echo SEP_ALL Weight 1
  echo SEP_ALL Delay 1
  echo SEP 0 2 Weight -1
  echo SEP 1 2 Weight $m

  echo SORT Q
  echo TJ tmp_network.txt
  
  ) | $fro/bin/network_tool

if [ $v = -1 ]; then exit 0; fi

( echo ML tmp_network.txt
  i=0
  while [ $i -lt $v ]; do echo ASV 0 $i 1; i=$(($i+1)); done
  echo AS 1 0 1
  echo RSC $mp1
) > tmp_pt_input.txt

$fro/bin/processor_tool_risp < tmp_pt_input.txt
