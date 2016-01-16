# Ping
## A very simple Kubernetes example



We have written our app. It's a microservice that says `ping!`. The service is exposed in port `8080`. You can run the app in your machine, in a container, and in a container that runs in Kubernetes.

* Run the app in your machine: assuming you have set up correctly your golang env, you just have to do `go run main.go`, then you can request the service `curl localhost:8080` and you should see the `ping!` result.

* Container: first you have to build your container, but before that, you have to build your service with all the dependencies (build.sh will do that for you). Then you build your container `docker build -t ipedrazas/ping` and finally you can run it: `docker run -it --rm -p 8080:8080 ipedrazas/ping`, then you can request the service `curl localhost:8080` and you should see the `ping!` result.


#### Kubernetes

The kubernetes artifacts are in a folder called `k8s`. There are 3 files:

* ping-pod.yaml: you don't really need this one, since the pod definition will be added in the replication controller, but it's good to have it as a reference
* ping-rc.yaml: replication controller. This file tells Kubernetes to create a pod with 1 container (ipedrazas/ping) and make sure there's always 1 instance ready
* ping-service.yaml: This service will expose our container publicly (because it's `type: LoadBalancer`) and redirects traffic from the loadbalancer (port 80) to the containers (port 8080). (IF you're using AWS, this instruction will create a LoadBalancer and bear in mind it takes a while to have all your instances added to the LB. Be patient :))

Let's create the replication controller:

    kubectl create -f k8s/ping-rc.yaml

Now, we expose the container usinga  service:

    kubectl create -f k8s/ping-service.yaml

To test our service, we need to get the endpoint, to do that, execute this command:

    kubectl describe service ping

You should have something like:

```
-> % kubectl describe service ping
Name:           ping
Namespace:      default
Labels:         name=ping
Selector:       name=ping
Type:           LoadBalancer
IP:         10.0.142.98
LoadBalancer Ingress:   a626b1846676611e5b34e06250624b2f.eu-west-1.elb.amazonaws.com
Port:           <unnamed>   80/TCP
NodePort:       <unnamed>   31970/TCP
Endpoints:      10.244.3.3:8080
Session Affinity:   None
No events.
```

where `a626b1846676611e5b34e06250624b2f.eu-west-1.elb.amazonaws.com` is our load balancer. If you do

    curl a626b1846676611e5b34e06250624b2f.eu-west-1.elb.amazonaws.com

you should get a `ping!` response


# How names, labels and selectors work?

Let's create the different components:

Replication controller plus pod:

        -> % kubectl create -f k8s/ping-rc.yaml
        replicationcontrollers/pingrcname

Service that exposes that replication controller

        -> % kubectl create -f k8s/ping-service.yaml
        services/pingsvcname

Now, let's look at the pods we have:

        -> % kubectl get pods
        NAME               READY     STATUS    RESTARTS   AGE
        pingrcname-jiw6h   1/1       Running   0          12s

        -> % kubectl get rc
        CONTROLLER   CONTAINER(S)    IMAGE(S)         SELECTOR            REPLICAS
        pingrcname   pingcontainer   ipedrazas/ping   name=pingpodlabel   1

Note that in our [ping-rc.yaml](ping-rc.yaml) we have given the name `pingrcname` to the replication controller and we have created a label `name: pingrc`

        apiVersion: v1
        kind: ReplicationController
        metadata:
          name: pingrcname
          labels:
            name: pingrc
        spec:
          replicas: 1
          selector:
            name: pingpodlabel
          template:
            metadata:
              labels:
                name: pingpodlabel
            spec:
              containers:
              - name: pingcontainer
                image: ipedrazas/ping
                ports:
                - containerPort: 8080

We can see that the name of our RC will be used as a prefix of the pods. Note as well, that the RC contains a containen named `pingcontainer` which is the name we gave it in the rc definition:

        containers:
        - name: pingcontainer

Finally, let's look at the service.

        -> % kubectl get service
        NAME          LABELS                                    SELECTOR            IP(S)         PORT(S)
        kubernetes    component=apiserver,provider=kubernetes   <none>              10.0.0.1      443/TCP
        pingsvcname   name=pingservice                          name=pingpodlabel   10.0.94.219   80/TCP

We can see that the service is called `pingsvcname`, that it has a label (remember labels are our grouping strategy), and that the selector is a label `name=pingpodlabel`, this label is a pod label, not a rc label.
