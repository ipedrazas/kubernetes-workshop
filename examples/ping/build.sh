# Docker From scratch is empty,
# there are no libraries and no loadpath.
# We have to statically compile our app with all libraries built in:
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ping .
