package main

import (
	"encoding/json"
	"net/http"
	"os"
)

var version = "dev"

func main() {
	http.HandleFunc("/", handleRoot)
	http.HandleFunc("/healthz", handleHealthz)
	http.HandleFunc("/readyz", handleReadyz)
	http.ListenAndServe(":8080", nil)
}

func handleRoot(w http.ResponseWriter, r *http.Request) {
	hostname, _ := os.Hostname()
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{
		"message":  "hello",
		"hostname": hostname,
		"version":  version,
	})
}

func handleHealthz(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("OK zoomer"))
}

func handleReadyz(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("OK"))
}
