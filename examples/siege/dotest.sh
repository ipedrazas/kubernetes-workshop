#!/bin/bash



ELB=$(kubectl describe svc siegetestsvc | grep "LoadBalancer Ingress" | awk '{print $3}')

for (( j = 1; j < 10; j++ )); do
    for i in $(seq 0 10 60); do
        if [[  $i -ne 0 ]]; then
            STEP="-t"$i"s"
            siege -lsiege.log -q $STEP $ELB
            echo $STEP
        fi
    done;
done

