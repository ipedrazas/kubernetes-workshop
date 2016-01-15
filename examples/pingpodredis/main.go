package main

import (
    "fmt"
    "gopkg.in/redis.v3"
    "log"
    "net/http"
    "os"
)

var redisClient *Redis

type Redis struct {
    *redis.Client
}

func (r Redis) getCount() (int64, error) {
    if err := redisClient.Incr("ping").Err(); err != nil {
        return -1, err
    }

    count, err := redisClient.Get("ping").Int64()
    if err != nil {
        return -1, err
    }
    return count, err
}

func pingServer(w http.ResponseWriter, req *http.Request) {
    var message string

    if count, err := redisClient.getCount(); err == nil {
        message = fmt.Sprintf("ping! %d", count)
    } else {
        message = err.Error()
    }
    w.Write([]byte(message))
}

func main() {
    uri := fmt.Sprintf("%s:6379", os.Getenv("REDIS_HOST"))
    redisClient = &Redis{
        redis.NewClient(&redis.Options{
            Addr:     uri,
            Password: "", // no password set
            DB:       0,  // use default DB
        }),
    }

    http.HandleFunc("/", pingServer)
    log.Fatal(http.ListenAndServe(":8080", nil))
}
