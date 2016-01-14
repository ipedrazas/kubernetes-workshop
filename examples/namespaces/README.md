# Namespaces

Namespaces are virtual clusters


You can create a `Namespace` using the following file:

__Namespace.yaml__

        kind: Namespace
        apiVersion: v1
        metadata:
          name: integration
          labels:
            name: integration
            env: integration
            scope: internal

To create a pod, you can either create it using the `--namespace=` flag or by adding the `namespace:` key to the pod definition (metadata section).

## Actions


Create a new namespace

        kubectl create -f namespace.yaml

List namespaces

        kubectl get namespaces

Set namespace by default

        kubectl config set-context CONTEXT --namespace=NAMESPACE

To get the current context:

        -> % kubectl config view | grep current-context
        current-context: aws_ivan

A better way of doing it:

    kubectl config view | grep current-context | awk '{print $2}'

Or even better, you can create a function that will automate this steps and set the namespace with a simple command

        function namespace(){
            CONTEXT=$(kubectl config view | grep current-context | awk '{print $2}')
            kubectl config set-context $CONTEXT --namespace=$1
        }

Now you can change between namespaces by doing

        -> % namespace default # changes to default namespace
        -> % namespace ci # changes to ci namespace
        -> % namespace production # changes to production namespace




