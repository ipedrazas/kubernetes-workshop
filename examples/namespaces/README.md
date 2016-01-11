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
