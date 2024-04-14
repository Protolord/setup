package main

import (
    "fmt"
    "net/http"
    "io/ioutil"
)

func main() {
    // Define a handler function for the root URL ("/")
    handler := func(w http.ResponseWriter, r *http.Request) {
        fmt.Printf("Request:\n%#v\n", r)
        body, err := ioutil.ReadAll(r.Body)
        if len(body) > 0 && err == nil {
            fmt.Println("Request Body:")
            fmt.Println(string(body))
        }
        fmt.Fprintf(w, "Receiver acknowledge")
    }

    // Register the handler function for the root URL ("/")
    http.HandleFunc("/", handler)

    // Start the HTTP server on port 8080
    fmt.Println("Server listening on port 8080...")
    http.ListenAndServe(":8080", nil)
}
