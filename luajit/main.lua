local ffi = require("ffi")

local SHA256_DIGEST_LENGTH = 32

ffi.cdef[[
    void SHA256_Init(void *ctx);
    void SHA256_Update(void *ctx, const void *data, size_t len);
    void SHA256_Final(unsigned char *md, void *ctx);
]]

local openssl = ffi.load("crypto")

local function sha256_double(input, input_len)
    local first_hash = ffi.new("unsigned char[32]")
    local ctx = ffi.new("unsigned char[112]")
    
    openssl.SHA256_Init(ctx)
    openssl.SHA256_Update(ctx, input, input_len)
    openssl.SHA256_Final(first_hash, ctx)
    
    local output = ffi.new("unsigned char[32]")
    local ctx2 = ffi.new("unsigned char[112]")
    
    openssl.SHA256_Init(ctx2)
    openssl.SHA256_Update(ctx2, first_hash, SHA256_DIGEST_LENGTH)
    openssl.SHA256_Final(output, ctx2)
    
    return output
end

local ITERATIONS = 200000000

local start_time = os.clock()
local last_report = start_time

local loops = 0
local count = 0

local current_input = "1"
local input_len = 1
local blockhash = nil

while count < ITERATIONS do
    blockhash = sha256_double(current_input, input_len)
    current_input = ffi.string(blockhash, SHA256_DIGEST_LENGTH)
    input_len = SHA256_DIGEST_LENGTH
    
    loops = loops + 1
    count = count + 1
    
    local now = os.clock()
    local elapsed = now - start_time
    local report_elapsed = now - last_report
    
    if report_elapsed >= 1.0 then
        local hash_str = ""
        for i = 0, SHA256_DIGEST_LENGTH - 1 do
            hash_str = hash_str .. string.format("%02x", blockhash[i])
        end
        
        print(string.format("Current blockhash: %s | %d ops/sec", hash_str, loops / elapsed))
        last_report = now
    end
end

local now = os.clock()
local total_time = now - start_time
local ops_per_sec = math.floor(loops / total_time)

local hash_str = ""
for i = 0, SHA256_DIGEST_LENGTH - 1 do
    hash_str = hash_str .. string.format("%02x", blockhash[i])
end

local result = {
    language = "LuaJIT",
    time = total_time,
    ops_per_sec = ops_per_sec,
    hash = hash_str
}

local json_str = string.format('{"language":"%s","time":%.2f,"ops_per_sec":%d,"hash":"%s"}',
    result.language, result.time, result.ops_per_sec, result.hash)
print(json_str)
