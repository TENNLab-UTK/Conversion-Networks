# This creates a V_{train} -> C_{time} and V_{train} -> C_{train}  network,
# and then applies a value to it.  It prints # the "RSC" output for 2max+1 timesteps.

if [ $# -ne 3 ]; then
  echo 'usage: sh scripts/04_Train_to_C_Time.sh M V os_framework - use -1 for V to not run' >&2
  exit 1
fi

m=$1
c=$2
fro=$3

mp1=$(($m+1))

for i in network_tool processor_tool_risp ; do
  if [ ! -x $fro/bin/$i ]; then
    ( cd $fro ; make bin/$i )
  fi
done

# Make an empty network with the proper RISP parameters.

cat $fro/params/risp_127.txt | sed 's/127/'$m'/g' > tmp_risp.txt

( echo M risp tmp_risp.txt
  echo EMPTYNET tmp_emptynet.txt ) | $fro/bin/processor_tool_risp

# Now create the network and put it into tmp_network.txt

( echo FJ tmp_emptynet.txt
  echo AN 0 1 2 3
  echo AI 0 1
  echo AO 0 3
  echo SETNAME 0 C_time
  echo SETNAME 1 S
  echo SETNAME 2 G
  echo SETNAME 3 C_train
  echo SNP_ALL Threshold 1
  echo SNP 0 Threshold $m

  echo AE 0 0    0 2
  echo AE 1 2    1 3
  echo AE 2 0    2 2    2 3

  echo SEP_ALL Weight 1
  echo SEP_ALL Delay 1
  echo SEP 0 0 Weight -1
  echo SEP 0 2 Weight -1
  echo SEP 1 3 Weight -1
  echo SEP 1 2 Delay $(($m-1))
  
  echo SORT Q
  echo TJ tmp_network.txt
  
  ) | $fro/bin/network_tool

if [ $c = -1 ]; then exit 0; fi

( echo ML tmp_network.txt
  i=0
  while [ $i -lt $c ]; do echo ASV 0 $i 1; i=$(($i+1)); done
  echo ASV 1 0 1
  echo RSC $(($m+$m+1))
) > tmp_pt_input.txt

$fro/bin/processor_tool_risp < tmp_pt_input.txt
