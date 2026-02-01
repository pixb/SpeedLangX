#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>
#include <time.h>
#include <jansson.h>

#define ITERATIONS 200000000

void sha256_double(const unsigned char *input, size_t len, unsigned char *output) {
    unsigned char first_hash[SHA256_DIGEST_LENGTH];
    SHA256(input, len, first_hash);
    SHA256(first_hash, SHA256_DIGEST_LENGTH, output);
}

int main() {
    struct timespec start, now;
    clock_gettime(CLOCK_MONOTONIC, &start);
    struct timespec last_report = start;
    
    unsigned long long loops = 0;
    unsigned long long count = 0;
    
    unsigned char blockhash[SHA256_DIGEST_LENGTH];
    unsigned char *current_input = (unsigned char *)"1";
    size_t input_len = 1;
    
    while (count < ITERATIONS) {
        sha256_double(current_input, input_len, blockhash);
        current_input = blockhash;
        input_len = SHA256_DIGEST_LENGTH;
        
        loops++;
        count++;
        
        clock_gettime(CLOCK_MONOTONIC, &now);
        double elapsed = (now.tv_sec - start.tv_sec) + (now.tv_nsec - start.tv_nsec) / 1e9;
        double report_elapsed = (now.tv_sec - last_report.tv_sec) + (now.tv_nsec - last_report.tv_nsec) / 1e9;
        
        if (report_elapsed >= 1.0) {
            char hash_str[65];
            for (int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
                sprintf(hash_str + i * 2, "%02x", blockhash[i]);
            }
            hash_str[64] = 0;
            
            printf("Current blockhash: %s | %llu ops/sec\n", hash_str, (unsigned long long)(loops / elapsed));
            last_report = now;
        }
    }
    
    clock_gettime(CLOCK_MONOTONIC, &now);
    double total_time = (now.tv_sec - start.tv_sec) + (now.tv_nsec - start.tv_nsec) / 1e9;
    unsigned long long ops_per_sec = (unsigned long long)(loops / total_time);
    
    char hash_str[65];
    for (int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        sprintf(hash_str + i * 2, "%02x", blockhash[i]);
    }
    hash_str[64] = 0;
    
    json_t *root = json_object();
    json_object_set_new(root, "language", json_string("C"));
    json_object_set_new(root, "time", json_real(total_time));
    json_object_set_new(root, "ops_per_sec", json_integer(ops_per_sec));
    json_object_set_new(root, "hash", json_string(hash_str));
    
    char *json_str = json_dumps(root, JSON_COMPACT);
    printf("%s\n", json_str);
    
    free(json_str);
    json_decref(root);
    
    return 0;
}
