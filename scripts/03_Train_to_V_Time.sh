# This creates a V_Train -> V_Time  network, and then applies a value to it.  It prints
# the "RSC" output for max+2 timesteps.

if [ $# -ne 3 ]; then
  echo 'usage: sh scripts/st_t.sh M V os_framework - use -1 for V to not run' >&2
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

# Make an empty network with the proper RISP parameters.

cat $fro/params/risp_127.txt | sed 's/127/'$m'/g' > tmp_risp.txt

( echo M risp tmp_risp.txt
  echo EMPTYNET tmp_emptynet.txt ) | $fro/bin/processor_tool_risp

# Now create the network and put it into tmp_network.txt

( echo FJ tmp_emptynet.txt
  echo AN 0 1 2 3
  echo AI 0 1
  echo AO 3
  echo SETNAME 0 E
  echo SETNAME 1 S
  echo SETNAME 2 F
  echo SETNAME 3 V_time
  echo SNP_ALL Threshold 1

  echo AE 0 2   0 3
  echo AE 1 3
  echo AE 2 3

  echo SEP_ALL Weight 1
  echo SEP_ALL Delay 1
  echo SEP 0 3 Weight -1
  
  echo SORT Q
  echo TJ tmp_network.txt
  
  ) | $fro/bin/network_tool

if [ $v = -1 ]; then exit 0; fi

( echo ML tmp_network.txt
  i=0
  while [ $i -lt $v ]; do echo AS 0 $i 1; i=$(($i+1)); done
  echo AS 1 0 1
  echo RSC $(($m+2))
) > tmp_pt_input.txt

$fro/bin/processor_tool_risp < tmp_pt_input.txt
