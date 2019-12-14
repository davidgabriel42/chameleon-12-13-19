	#!/bin/bash
function run_tstat()
{
        sudo ./tstat -l -i eno1 -s  $1 &
        TSTAT_PID=$!
        echo "TSTAT Started, PID = $TSTAT_PID"
        sleep 1
        for i in {1..60}
                do
                        for j in {1..6}
                                do
                                        echo "Starting iPerf Test #$i.$j"
                                        sudo iperf3 -c 10.52.1.28  -t 10
                                        echo "iPerf Complete"
                                done
                done
        kill -s INT $TSTAT_PID
}


#clear settings

sudo tc qdisc del dev eno1 root netem

#run
sudo tc qdisc add dev eno1 root netem loss 5%
run_tstat  OUT_DATA/loss_5perc
sudo tc qdisc del dev eno1 root netem

sudo tc qdisc add dev eno1 root netem loss 10%
run_tstat  OUT_DATA/loss_10perc  
sudo tc	qdisc del dev eno1 root	netem

sudo tc qdisc add dev eno1 root netem loss 15%
run_tstat  OUT_DATA/loss_15perc  
sudo tc	qdisc del dev eno1 root	netem

tc qdisc add dev eno1 root netem delay 25ms 20ms distribution normal
run_tstat  OUT_DATA/delay_25_var_20
tc qdisc del dev eno1 root netem delay 25ms 20ms distribution normal

tc qdisc add dev eno1 root netem delay 10ms 5ms distribution normal
run_tstat  OUT_DATA/delay_10_var_5
tc qdisc del dev eno1 root netem delay 10ms 5ms distribution normal

tc qdisc add dev eno1 root netem delay 5ms 2ms distribution normal
run_tstat  OUT_DATA/delay_5_var_2
tc qdisc del dev eno1 root netem delay 5ms 2ms distribution normal

tc qdisc add dev eno1 root netem delay 100ms 20ms distribution normal
run_tstat  OUT_DATA/delay_1_var_1
tc qdisc del dev eno1 root netem delay 100ms 20ms distribution normal

tc qdisc add dev eno1 root netem duplicate 1%
run_tstat  OUT_DATA/dup_1perc
tc qdisc del dev eno1 root netem duplicate 1%

tc qdisc add dev eno1 root netem duplicate 3%
run_tstat  OUT_DATA/dup_3perc
tc qdisc del dev eno1 root netem duplicate 3%

tc qdisc add dev eno1 root netem duplicate 2%
run_tstat  OUT_DATA/dup_2perc
tc qdisc del dev eno1 root netem duplicate 2%

tc qdisc add dev eno1 root netem corrupt 0.1%
run_tstat  OUT_DATA/corrupt_0.1perc
tc qdisc del dev eno1 root netem corrupt 0.1%

tc qdisc add dev eno1 root netem corrupt 0.5%
run_tstat  OUT_DATA/corrupt_0.5perc
tc qdisc del dev eno1 root netem corrupt 0.5%

tc qdisc add dev eno1 root netem corrupt 1.0%
run_tstat  OUT_DATA/corrupt_1.0perc
tc qdisc del dev eno1 root netem corrupt 1.0%
