# PingPodRedis
## Kubernetes and state

In this example we're going to see what happens when we use a simple app that reads and writes to a database

We're going to run 2 containers in one pod


* pingredis-rc: replication controller that defines our pod that contains our app container and a redis container.
* pingredis-svc: loadbalancer that exposes our App to the world.

    kubectl create -f k8s/pingpodredis-rc.yaml
    kubectl create -f k8s/pingpodredis-svc.yaml

Note that our app connects to `localhost:6379`, the objective of this test is to understand a little bit more how dependencies work.

    - name: pingredis
        image: ipedrazas/pingpodredis
        ports:
        - containerPort: 8080
        env:
          - name: REDIS_HOST
            value: "localhost"
