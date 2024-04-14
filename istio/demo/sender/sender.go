package main

import (
    "fmt"
    "bytes"
    "net/http"
    "encoding/json"
    "time"
    "github.com/google/uuid"
)

func main() {
    client := http.Client{}
    fmt.Println("Wait for 30 seconds before starting")
    time.Sleep(30*time.Second)

    for {
        jsonData := map[string]string{
            "reqId": uuid.New().String(),
        }
        jsonBytes, err := json.Marshal(jsonData)
        fmt.Println("Request:", string(jsonBytes))
        req, err := http.NewRequest(
            "POST",
            "http://receiver-svc.istio-demo-rx.svc.cluster.local:8080",
            bytes.NewBuffer(jsonBytes),
        )
        if err != nil {
            fmt.Println("Error creating request:", err)
            return
        }
        req.Header.Set("Content-Type", "application/json")

        fmt.Println("Sending request")
        resp, err := client.Do(req)
        if err != nil {
            fmt.Println("Error sending HTTP:", err)
            return
        }

        fmt.Printf("Response:\n%#v\n", resp)
        resp.Body.Close()
        time.Sleep(5*time.Second)
    }
}
