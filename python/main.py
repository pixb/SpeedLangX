import hashlib
import time
import json

ITERATIONS = 200000000

start_time = time.time()
last_report = start_time

loops = 0
count = 0

current_input = b"1"
blockhash = None

while count < ITERATIONS:
    first = hashlib.sha256(current_input).digest()
    blockhash = hashlib.sha256(first).digest()
    current_input = blockhash
    
    loops += 1
    count += 1
    
    now = time.time()
    if now - last_report >= 1.0:
        elapsed = now - start_time
        print(f"Current blockhash: {blockhash.hex()} | {int(loops / elapsed)} ops/sec")
        last_report = now

total_time = time.time() - start_time
ops_per_sec = int(loops / total_time)

result = {
    "language": "Python",
    "time": total_time,
    "ops_per_sec": ops_per_sec,
    "hash": blockhash.hex()
}

print(json.dumps(result))
