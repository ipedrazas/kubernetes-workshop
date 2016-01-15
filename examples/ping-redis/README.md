# Ping-Redis
## Kubernetes and state

In this example we're going to see what happens when we use a simple app that reads and writes to a database

We're going to create 2 `Replication Controllers` and 2 `Services`


* redis-rc: pod that defines a redis container.
* redis-svc: internal service that exposes redis.
* pingredis-rc: pod that defines our app container.
* pingredis-svc: loadbalancer that exposes our App to the world.


    kubectl create -f k8s/redis-rc.yaml
    kubectl create -f k8s/redis-svc.yaml
    kubectl create -f k8s/pingredis-rc.yaml
    kubectl create -f k8s/pingredis-svc.yaml


Now you should have 2 pods (redis-XXXXX and pingredis-XXXXX) and 2 services (redis and pingredis).

    kubectl describe service pingredis

This command will return the public url and port that we have to use to call our app.

    -> % kubectl describe service pingredis
        Name:           pingredis
        Namespace:      default
        Labels:         name=pingredis
        Selector:       name=pingredis
        Type:           LoadBalancer
        IP:         10.0.192.22
        LoadBalancer Ingress:   a2b7c0daa678411e5b34e06250624b2f.eu-west-1.elb.amazonaws.com
        Port:           <unnamed>   80/TCP
        NodePort:       <unnamed>   32577/TCP
        Endpoints:      10.244.1.6:8080
        Session Affinity:   None
        No events.

Now, if we do an http request to the loadbalacer we should have our app result back:

    -> % http a2b7c0daa678411e5b34e06250624b2f-1716499263.eu-west-1.elb.amazonaws.com/
    HTTP/1.1 200 OK
    Content-Length: 9
    Content-Type: text/plain; charset=utf-8
    Date: Wed, 30 Sep 2015 15:29:06 GMT

    ping! 1

Note: I use [httpie](https://github.com/jkbrzt/httpie) instead of curl

## What happened here?

We have a simple app that exposes an HTTP endpoint and read/writes from a database. Nothing new. What it is slilghtly different is that the app talks
to a service that talks to a container. If you look at the `main.go` code, you will see that we create a redis client passing 2 parameters: host and port.
In our case `host=redis` and `port=6379`.

But, where is this redis coming from? it is our redis-svc service!

Remember good old docker?

    docker run -it -p 8080:8080 --link redis:redis ipedrazas/pingredis

This is how you run our pingredis container manually. Note that link? do you remember how links work? well, Kubernetes services work in a similar way .

What happens is that when you create a service (and if you are running a dns service) a new entry is created in that dns.
