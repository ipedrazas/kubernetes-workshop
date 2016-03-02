#!/bin/bash



ELB=$(kubectl describe svc siegetestsvc | grep "LoadBalancer Ingress" | awk '{print $3}')

# for (( j = 1; j < 10; j++ )); do
#     for i in $(seq 0 10 60); do
#         if [[  $i -ne 0 ]]; then
#             STEP="-t"$i"s"
#             siege -lsiege.log -q $STEP $ELB
#             echo $STEP
#         fi
#     done;
# done

# for iter in $(seq 0 10 60); do
#     echo "Iteration number $ITER ";
#     for (( j = 1; j < 5; j++ )); do
#         for i in $(seq 0 100 1000); do
#             if [[  $i -ne 0 ]]; then
#                 STEP="-t$ITERs -c$i"
#                 LOG="-lsiege-$ITER.log"
#                 siege $LOG -q $STEP $ELB
#             fi
#         done;
#     done;
# done;

ulimit -n 30000

for REPLICAS in $(seq 4 4 12); do
    if [[  $ITER -ne 0 ]]; then
        kubectl scale rc siegetest --replicas=$REPLICAS
    else
        kubectl scale rc siegetest --replicas=1
    fi


    for i in $(kubectl get pods | awk '{print $1}' | grep siege); do
        kubectl describe pod $i | grep Node;
    done;

        #statements
    for ITER in $(seq 0 10 30); do
        # for (( j = 1; j < 4; j++ )); do
            for i in $(seq 0 100 800); do
                if [[  $ITER -ne 0 ]]; then
                    if [[  $i -ne 0 ]]; then
                        STEP="-t"$ITER"s -c$i"
                        LOG="-lsiege-4n-"$REPLICAS"replicas-"$ITER"s.log"
                        echo "siege $LOG -q $STEP $ELB"
                        siege $LOG -q $STEP $ELB
                    fi
                fi
            done;
        # done;
    done;
done;


# To scale up and down RCs
#kubectl scale rc siegetest --replicas=10
