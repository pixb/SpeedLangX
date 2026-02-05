package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"time"
)

func main() {
	start := time.Now()
	lastReport := start
	count := 0

	// 初始输入是单字节 '1'，与 Rust 代码保持一致
	currentInput := []byte("1")
	blockhash := [32]byte{}

	const reportInterval = 10_000_000
	const totalOps = 200_000_000

	for count < totalOps {
		first := sha256.Sum256(currentInput)
		blockhash = sha256.Sum256(first[:])
		currentInput = blockhash[:]

		count++

		if count%reportInterval == 0 {
			now := time.Now()
			elapsedSinceLast := now.Sub(lastReport).Seconds()
			if elapsedSinceLast >= 1.0 {
				totalElapsed := now.Sub(start).Seconds()
				fmt.Printf("Current blockhash: %s | %d ops/sec\n",
					hex.EncodeToString(blockhash[:]),
					int64(float64(count)/totalElapsed))
				lastReport = now
			}
		}
	}

	total := time.Since(start).Seconds()
	result := map[string]interface{}{
		"language":    "Go",
		"time":        total,
		"ops_per_sec": int64(float64(count) / total),
		"hash":        hex.EncodeToString(blockhash[:]),
	}
	jsonData, _ := json.Marshal(result)
	fmt.Println(string(jsonData))
}
