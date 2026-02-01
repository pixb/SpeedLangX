use ring::digest::{digest, SHA256};
use hex;
use std::time::Instant;
use serde_json;

fn main() {
    let start_time = Instant::now();
    let mut last_report = start_time;
    let mut loops = 0u64;
    let mut count = 0u64;

    let mut blockhash = [0u8; 32];

    let mut current_input: &[u8] = b"1";

    while count < 200_000_000u64 {
        let first = digest(&SHA256, current_input);
        let second = digest(&SHA256, first.as_ref());
        blockhash.copy_from_slice(second.as_ref());
        current_input = &blockhash;

        loops += 1;
        count += 1;

        let now = Instant::now();
        if now.duration_since(last_report).as_secs() >= 1 {
            let elapsed = start_time.elapsed().as_secs_f64();
            println!(
                "Current blockhash: {} | {} ops/sec",
                hex::encode(&blockhash),
                (loops as f64 / elapsed) as u64
            );
            last_report = now;
        }
    }

    let total_time = start_time.elapsed().as_secs_f64();
    let ops_per_sec = (loops as f64 / total_time) as u64;
    
    println!("{}", serde_json::json!({
        "language": "Rust",
        "time": total_time,
        "ops_per_sec": ops_per_sec,
        "hash": hex::encode(&blockhash)
    }));
}