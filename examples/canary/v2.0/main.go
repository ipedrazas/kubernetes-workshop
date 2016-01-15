package main

import (
    "log"
    "net/http"
)


func pingServer(w http.ResponseWriter, req *http.Request) {
    w.Write([]byte("simple api v2.0!"))
}

func main() {
    http.HandleFunc("/", pingServer)
    err := http.ListenAndServe(":8080", nil)
    if err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}
