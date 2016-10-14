# Deploying an application

In this example we're going to deploy a very simple application. To do that, we have to

* write an application
* create a docker image
* push the docker image to a registry
* create a `Deployment` file
* submit that file to our kubernetes cluster

You can find a simple application in [this directoy](../workshopui), let's create a docker image with it:

    docker build ipedrazas/workshopui:1.0.0 .

Note that you will have to use your own registry user (in my case is `ipedrazas`) for the docker image

    docker push ipedrazas/workshopui

Now we can use the following file to submit our claim to the cluster:

    kubectl create -f deployment.yaml

And... we go and check if the pods are being created:

    kubectl get pods

Once they are up and running, let's test them. Since we don't have any service yet, let's use the `port-forward` option

    kubectl port-forward frontend-2546943484-bebwq 8000:80

This exposes the port 80 of the pod `frontend-2546943484-bebwq` in our localhost:8000, if now we do

    -> % curl localhost:8000
    <html>
    <head>
    <title>Kubernetes Workshop</title>
    </head>
    <body>
    Welcome to the kubernetes workshop!
    </body>
    </html>

Excellent, let's update our application and update the deployment:

    docker build ipedrazas/workshopui:1.0.1 .
    docker push ipedrazas/workshopui

Now, we use the new deployment descriptor `deployment-2.yaml`.

    kubectl apply -f deployment-2.yaml

And if we check what's going on we will see that a few pods are being created and others are being terminated

    -> % kubectl get pods
    NAME                        READY     STATUS              RESTARTS   AGE
    frontend-2546943484-2i38r   1/1       Running             0          18m
    frontend-2546943484-bebwq   1/1       Terminating         0          18m
    frontend-2546943484-x00l9   1/1       Running             0          18m
    frontend-2650949117-bpemm   0/1       ContainerCreating   0          2s
    frontend-2650949117-es92l   0/1       ContainerCreating   0          2s

Finally, we will see that the new pods have been updated.


What happened here? well, we had 3 pods running that needed to be updated and kubernetes has used our `Deployment`
file to know what does he have to do and how.

In the Deployment file you specify what are you deploying (containers), how many replicas do you want to be created, and how do you want them to be updated.

Every application is different, but `Deployment` artifacts give you the flexibility to update and scale your application according to your needs.
