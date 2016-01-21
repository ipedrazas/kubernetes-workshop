package main

import (
	"fmt"
	"log"
	"net/http"
)

func pingServer(w http.ResponseWriter, req *http.Request) {
	w.Write([]byte("ping! Simple and Updated....  v1.0.0"))
}

func main() {
	fmt.Println("Api version v1.0.0 -- Listening in port 8080")
	http.HandleFunc("/", pingServer)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
