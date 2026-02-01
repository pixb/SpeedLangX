#include <iostream>
#include <string>
#include <vector>
#include <chrono>
#include <openssl/sha.h>
#include <nlohmann/json.hpp>

#define ITERATIONS 200000000

using json = nlohmann::json;

void sha256_double(const unsigned char *input, size_t len, unsigned char *output) {
    unsigned char first_hash[SHA256_DIGEST_LENGTH];
    SHA256(input, len, first_hash);
    SHA256(first_hash, SHA256_DIGEST_LENGTH, output);
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    auto last_report = start;
    
    unsigned long long loops = 0;
    unsigned long long count = 0;
    
    unsigned char blockhash[SHA256_DIGEST_LENGTH];
    std::vector<unsigned char> current_input = {'1'};
    size_t input_len = 1;
    
    while (count < ITERATIONS) {
        sha256_double(current_input.data(), input_len, blockhash);
        current_input.assign(blockhash, blockhash + SHA256_DIGEST_LENGTH);
        input_len = SHA256_DIGEST_LENGTH;
        
        loops++;
        count++;
        
        auto now = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> elapsed = now - start;
        std::chrono::duration<double> report_elapsed = now - last_report;
        
        if (report_elapsed.count() >= 1.0) {
            std::string hash_str;
            char buf[3];
            for (int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
                snprintf(buf, sizeof(buf), "%02x", blockhash[i]);
                hash_str += buf;
            }
            
            std::cout << "Current blockhash: " << hash_str << " | " 
                      << static_cast<unsigned long long>(loops / elapsed.count()) 
                      << " ops/sec" << std::endl;
            last_report = now;
        }
    }
    
    auto now = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> total_time = now - start;
    unsigned long long ops_per_sec = static_cast<unsigned long long>(loops / total_time.count());
    
    std::string hash_str;
    char buf[3];
    for (int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        snprintf(buf, sizeof(buf), "%02x", blockhash[i]);
        hash_str += buf;
    }
    
    json result;
    result["language"] = "C++";
    result["time"] = total_time.count();
    result["ops_per_sec"] = ops_per_sec;
    result["hash"] = hash_str;
    
    std::cout << result.dump() << std::endl;
    
    return 0;
}
