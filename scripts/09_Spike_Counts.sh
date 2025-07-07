# This creates the spike-counting network, and then applies Y and N spikes.

if [ $# -ne 4 ]; then
  echo 'usage: sh scripts/st_t.sh M Y N os_framework - use -1 for Y to not run' >&2
  exit 1
fi

m=$1
y=$2
n=$3
fro=$4

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
  echo AN 0 1 2   3 4   5 6 7 8 9  10 11
  echo AI 0 1 2
  echo AO 10 11
  echo SETNAME 0 CY
  echo SETNAME 1 S
  echo SETNAME 2 CN
  echo SETNAME 3 G
  echo SETNAME 4 G
  echo SETNAME 5 A
  echo SETNAME 6 B
  echo SETNAME 7 C
  echo SETNAME 8 D
  echo SETNAME 9 E
  echo SETNAME 10 Y
  echo SETNAME 11 N

  echo SNP_ALL Threshold 1
  echo SNP 0 Threshold $m
  echo SNP 2 Threshold $m
  echo SNP 7 Threshold 2

  echo AE 0 0  0 3  0 5
  echo AE 1 3  1 4
  echo AE 2 2  2 4  2 6

  echo AE 3 3  3 0
  echo AE 4 4  4 2

  echo AE 5 6   5 7   5 8
  echo AE 6 5   6 7   6 9
  echo AE 7 5   7 6   7 8   7 9  7 10
  echo AE 8 7   8 10
  echo AE 9 7   9 11

  echo SEP_ALL Weight 1
  echo SEP_ALL Delay 1
  echo SEP 0 0 Weight -1
  echo SEP 0 3 Weight -1

  echo SEP 2 2 Weight -1
  echo SEP 2 4 Weight -1
  echo SEP 5 6 Weight -1
  echo SEP 6 5 Weight -1
  echo SEP 7 8 Weight -1
  echo SEP 7 9 Weight -1
  echo SEP 8 7 Weight -1
  echo SEP 9 7 Weight -1
  
  echo SEP 1 3 Delay $(($m-1))
  echo SEP 1 4 Delay $(($m-1))
  echo SEP 5 8 Delay 2
  echo SEP 6 9 Delay 2

  echo SORT Q
  echo TJ tmp_network.txt
  
  ) | $fro/bin/network_tool

if [ $y = -1 ]; then exit 0; fi

# Create the processor_tool input and run it.

( echo ML tmp_network.txt
  i=0
  while [ $i -lt $y ]; do echo ASV 0 $i 1; i=$(($i+1)); done
  i=0
  while [ $i -lt $n ]; do echo ASV 2 $i 1; i=$(($i+1)); done
  echo ASV 1 0 1
  echo RSC $(($m+$m+3))
) > tmp_pt_input.txt

$fro/bin/processor_tool_risp < tmp_pt_input.txt
