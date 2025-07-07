# Network to convert a value to a time or spike train: V_{value} -> V_{time} and V_{value} -> V_{train}

This is Figure 9 in the paper:

![../jpg/figure_09.jpg](../jpg/figure_09.jpg)

If you haven't done so already, I recommend going through the
[main README for this repo](../README.md), and its 
[accompanying video](X).  That will get you familiar with RISP, the open-source framework,
and how we walk through these networks.

The main shell script for this network is 
`scripts/05_Time_to_V_Train.sh`.  You call it with the maximum value *M*, the value
you want to convert, and the open-source framework:


```
UNIX> echo $fro
/Users/plank/src/repos/framework-open
UNIX> sh sh scripts/07_Value_to_V_Train.sh
usage: sh scripts/07_Value_to_V_Train.sh M V os_framework - use -1 for V to not run
UNIX> sh scripts/07_Value_to_V_Train.sh 8 3 $fro

# V is 3 and M is 8.
# You run this for 2M+3 = 19 timesteps
# As you see below, V_Train spikes for three timesteps starting at timestep M+3 = 11.
# And V_time spikes at timestep (M+2)+3 = 13.

Time  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time) |  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time)
   0          -          *          -          -          - |          3          0          0          0          0
   1          -          -          *          -          - |          4          0          0          0          0
   2          -          -          *          -          - |          5          0          0          0          1
   3          -          -          *          -          - |          6          0          0          0          2
   4          -          -          *          -          - |          7          0          0          0          3
   5          -          -          *          -          - |          8          0          0          0          4
   6          *          -          *          -          - |          0          0          0          0          5
   7          -          -          -          -          - |          0          0          0          0          6
   8          -          -          -          -          - |          0          0          0          0          6
   9          -          -          -          -          - |          0          0          0          0          6
  10          -          -          -          -          - |          0          0          0          0          6
  11          -          -          -          *          - |          0          0          0          0          7
  12          -          -          -          *          - |          0          0          0          0          8
  13          -          -          -          *          * |          0          0          0          0          0
  14          -          -          -          -          - |          0          0          0          0          0
  15          -          -          -          -          - |          0          0          0          0          0
  16          -          -          -          -          - |          0          0          0          0          0
  17          -          -          -          -          - |          0          0          0          0          0
  18          -          -          -          -          - |          0          0          0          0          0
UNIX> sh scripts/07_Value_to_V_Train.sh 8 4 $fro

# V is 4 and M is 8.
# Now, V_Train spikes for four timesteps starting at timestep M+3 = 11.
# And V_time spikes at timestep (M+2)+4 = 14.

Time  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time) |  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time)
   0          -          *          -          -          - |          4          0          0          0          0
   1          -          -          *          -          - |          5          0          0          0          0
   2          -          -          *          -          - |          6          0          0          0          1
   3          -          -          *          -          - |          7          0          0          0          2
   4          -          -          *          -          - |          8          0          0          0          3
   5          *          -          *          -          - |          0          0          0          0          4
   6          -          -          -          -          - |          0          0          0          0          5
   7          -          -          -          -          - |          0          0          0          0          5
   8          -          -          -          -          - |          0          0          0          0          5
   9          -          -          -          -          - |          0          0          0          0          5
  10          -          -          -          -          - |          0          0          0          0          5
  11          -          -          -          *          - |          0          0          0          0          6
  12          -          -          -          *          - |          0          0          0          0          7
  13          -          -          -          *          - |          0          0          0          0          8
  14          -          -          -          *          * |          0          0          0          0          0
  15          -          -          -          -          - |          0          0          0          0          0
  16          -          -          -          -          - |          0          0          0          0          0
  17          -          -          -          -          - |          0          0          0          0          0
  18          -          -          -          -          - |          0          0          0          0          0
UNIX> sh scripts/07_Value_to_V_Train.sh 8 8 $fro

# V is 8 and M is 8.
# Now, V_Train spikes for eight timesteps starting at timestep M+3 = 11.
# And V_time spikes at timestep (M+2)+8 = 18.

Time  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time) |  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time)
   0          -          *          -          -          - |          8          0          0          0          0
   1          *          -          *          -          - |          0          0          0          0          0
   2          -          -          -          -          - |          0          0          0          0          1
   3          -          -          -          -          - |          0          0          0          0          1
   4          -          -          -          -          - |          0          0          0          0          1
   5          -          -          -          -          - |          0          0          0          0          1
   6          -          -          -          -          - |          0          0          0          0          1
   7          -          -          -          -          - |          0          0          0          0          1
   8          -          -          -          -          - |          0          0          0          0          1
   9          -          -          -          -          - |          0          0          0          0          1
  10          -          -          -          -          - |          0          0          0          0          1
  11          -          -          -          *          - |          0          0          0          0          2
  12          -          -          -          *          - |          0          0          0          0          3
  13          -          -          -          *          - |          0          0          0          0          4
  14          -          -          -          *          - |          0          0          0          0          5
  15          -          -          -          *          - |          0          0          0          0          6
  16          -          -          -          *          - |          0          0          0          0          7
  17          -          -          -          *          - |          0          0          0          0          8
  18          -          -          -          *          * |          0          0          0          0          0
UNIX> sh scripts/07_Value_to_V_Train.sh 8 0 $fro

# V is 0 and M is 8.
# Now, V_Train does not spike.
# And V_time spikes at timestep (M+2)+0 = 10.

Time  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time) |  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time)
   0          -          *          -          -          - |          0          0          0          0          0
   1          -          -          *          -          - |          1          0          0          0          0
   2          -          -          *          -          - |          2          0          0          0          1
   3          -          -          *          -          - |          3          0          0          0          2
   4          -          -          *          -          - |          4          0          0          0          3
   5          -          -          *          -          - |          5          0          0          0          4
   6          -          -          *          -          - |          6          0          0          0          5
   7          -          -          *          -          - |          7          0          0          0          6
   8          -          -          *          -          - |          8          0          0          0          7
   9          *          -          *          -          - |          0          0          0          0          8
  10          -          -          -          -          * |          0          0          0          0          0
  11          -          -          -          -          - |          0          0          0          0          0
  12          -          -          -          -          - |          0          0          0          0          0
  13          -          -          -          -          - |          0          0          0          0          0
  14          -          -          -          -          - |          0          0          0          0          0
  15          -          -          -          -          - |          0          0          0          0          0
  16          -          -          -          -          - |          0          0          0          0          0
  17          -          -          -          -          - |          0          0          0          0          0
  18          -          -          -          -          - |          0          0          0          0          0
UNIX> 
```

Let's take a look at the network.  See how it matches the picture above:

```
UNIX> ( echo FJ tmp_network.txt ; echo SORT Q ; echo TJ ) | $fro/bin/network_tool
{ "Properties":
  { "node_properties": [
      { "name":"Threshold", "type":73, "index":0, "size":1, "min_value":0.0, "max_value":11.0 }],
    "edge_properties": [
      { "name":"Delay", "type":73, "index":1, "size":1, "min_value":1.0, "max_value":11.0 },
      { "name":"Weight", "type":73, "index":0, "size":1, "min_value":-11.0, "max_value":11.0 }],
    "network_properties": [] },
 "Nodes":
  [ {"id":0,"name":"C_time","values":[9.0]},
    {"id":1,"name":"S","values":[1.0]},
    {"id":2,"name":"D","values":[1.0]},
    {"id":3,"name":"V_train","values":[1.0]},
    {"id":4,"name":"V_time","values":[9.0]} ],
 "Edges":
  [ {"from":0,"to":0,"values":[-1.0,1.0]},
    {"from":0,"to":2,"values":[-1.0,1.0]},
    {"from":1,"to":0,"values":[1.0,1.0]},
    {"from":1,"to":2,"values":[1.0,1.0]},
    {"from":1,"to":3,"values":[1.0,11.0]},
    {"from":1,"to":4,"values":[1.0,11.0]},
    {"from":2,"to":0,"values":[1.0,1.0]},
    {"from":2,"to":2,"values":[1.0,1.0]},
    {"from":2,"to":4,"values":[1.0,1.0]},
    {"from":3,"to":3,"values":[1.0,1.0]},
    {"from":3,"to":4,"values":[1.0,1.0]},
    {"from":4,"to":3,"values":[-1.0,1.0]},
    {"from":4,"to":4,"values":[-1.0,1.0]} ],
 "Inputs": [0,1],
 "Outputs": [0,3,4],
 "Network_Values": [],
 "Associated_Data":
   { "other": {"proc_name":"risp"},
     "proc_params": 
      { "discrete": true,
        "fire_like_ravens": false,
        "leak_mode": "none",
        "max_delay": 11,
        "max_threshold": 11.0,
        "max_weight": 11.0,
        "min_potential": -11.0,
        "min_threshold": 0.0,
        "min_weight": -11.0,
        "run_time_inclusive": false,
        "spike_value_factor": 11.0,
        "threshold_inclusive": true}}}
UNIX> 
```

Finally, let's take a look at the processor_tool commands when V=3:

```
UNIX> sh scripts/07_Value_to_V_Train.sh 8 3 $fro > /dev/null
UNIX> cat tmp_pt_input.txt 
ML tmp_network.txt
ASV 0 0 3                  # Here's the spike with a value of 3 (ASV spikes an actual value -- AS normalizes)
AS 1 0 1                   # And we cause S to spike at timestep 0
RSC 19                     # Run for 2M+3 = 19 timesteps, and print the spike raster and potentials
UNIX> $fro/bin/processor_tool_risp < tmp_pt_input.txt
Time  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time) |  0(C_time)       1(S)       2(D) 3(V_train)  4(V_time)
   0          -          *          -          -          - |          3          0          0          0          0
   1          -          -          *          -          - |          4          0          0          0          0
   2          -          -          *          -          - |          5          0          0          0          1
   3          -          -          *          -          - |          6          0          0          0          2
   4          -          -          *          -          - |          7          0          0          0          3
   5          -          -          *          -          - |          8          0          0          0          4
   6          *          -          *          -          - |          0          0          0          0          5
   7          -          -          -          -          - |          0          0          0          0          6
   8          -          -          -          -          - |          0          0          0          0          6
   9          -          -          -          -          - |          0          0          0          0          6
  10          -          -          -          -          - |          0          0          0          0          6
  11          -          -          -          *          - |          0          0          0          0          7
  12          -          -          -          *          - |          0          0          0          0          8
  13          -          -          -          *          * |          0          0          0          0          0
  14          -          -          -          -          - |          0          0          0          0          0
  15          -          -          -          -          - |          0          0          0          0          0
  16          -          -          -          -          - |          0          0          0          0          0
  17          -          -          -          -          - |          0          0          0          0          0
  18          -          -          -          -          - |          0          0          0          0          0
UNIX> 
```
