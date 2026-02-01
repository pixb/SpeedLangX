package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"time"
)

func doubleSha256(data []byte) []byte {
	first := sha256.Sum256(data)
	second := sha256.Sum256(first[:])
	return second[:]
}
func main() {
	start := time.Now()
	lastReport := start
	loops := 0
	count := 0
	blockhash := []byte("1")
	for count < 200_000_000 {
		blockhash = doubleSha256(blockhash)
		loops++
		count++
		now := time.Now()
		if now.Sub(lastReport).Seconds() >= 1.0 {
			elapsed := now.Sub(start).Seconds()
			fmt.Printf("Current blockhash: %s | %d ops/sec\n",
				hex.EncodeToString(blockhash),
				int64(float64(loops)/elapsed))
			lastReport = now
		}
	}
	total := time.Since(start).Seconds()
	opsPerSec := int64(float64(loops) / total)

	result := map[string]interface{}{
		"language":    "Go",
		"time":        total,
		"ops_per_sec": opsPerSec,
		"hash":        hex.EncodeToString(blockhash),
	}
	jsonData, _ := json.Marshal(result)
	fmt.Println(string(jsonData))
}
