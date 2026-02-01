#!/usr/bin/env python3
import json
import subprocess
import sys
import platform
from datetime import datetime
from tabulate import tabulate

def get_hardware_info():
    info = {}
    
    # Operating System
    system = platform.system()
    if system == 'Darwin':
        version = subprocess.run(['sw_vers', '-productVersion'], capture_output=True, text=True).stdout.strip()
        info['OS'] = f"macOS {version}"
    elif system == 'Linux':
        try:
            with open('/etc/os-release') as f:
                for line in f:
                    if line.startswith('PRETTY_NAME='):
                        info['OS'] = line.split('=')[1].strip('"')
                        break
        except:
            info['OS'] = 'Linux'
    elif system == 'Windows':
        info['OS'] = f"Windows {platform.release()}"
    else:
        info['OS'] = system
    
    # CPU
    if system == 'Darwin':
        cpu = subprocess.run(['sysctl', '-n', 'machdep.cpu.brand_string'], capture_output=True, text=True).stdout.strip()
        info['CPU'] = cpu
    elif system == 'Linux':
        try:
            with open('/proc/cpuinfo') as f:
                for line in f:
                    if line.startswith('model name'):
                        info['CPU'] = line.split(':')[1].strip()
                        break
        except:
            info['CPU'] = 'Unknown'
    elif system == 'Windows':
        info['CPU'] = platform.processor()
    else:
        info['CPU'] = 'Unknown'
    
    # Memory
    if system == 'Darwin':
        mem_bytes = int(subprocess.run(['sysctl', '-n', 'hw.memsize'], capture_output=True, text=True).stdout.strip())
        info['Memory'] = f"{mem_bytes // (1024**3)} GB"
    elif system == 'Linux':
        try:
            with open('/proc/meminfo') as f:
                for line in f:
                    if line.startswith('MemTotal:'):
                        mem_kb = int(line.split()[1])
                        info['Memory'] = f"{mem_kb // (1024**2)} GB"
                        break
        except:
            info['Memory'] = 'Unknown'
    elif system == 'Windows':
        import psutil
        info['Memory'] = f"{psutil.virtual_memory().total // (1024**3)} GB"
    else:
        info['Memory'] = 'Unknown'
    
    return info

def run_benchmark(binary):
    result = subprocess.run([binary], capture_output=True, text=True)
    output = result.stdout.strip().split('\n')[-1]
    try:
        data = json.loads(output)
        return data
    except json.JSONDecodeError:
        return None

def save_result(hw_info, rust_result, go_result, c_result, cpp_result):
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    entry = f"""## Benchmark Result - {timestamp}

### Hardware
- **OS**: {hw_info.get('OS', 'Unknown')}
- **CPU**: {hw_info.get('CPU', 'Unknown')}
- **Memory**: {hw_info.get('Memory', 'Unknown')}

### Results
| Language | Time (s) | Ops/sec | Hash |
|----------|-----------|----------|-------|
| {rust_result['language']} | {rust_result['time']:.2f} | {rust_result['ops_per_sec']:,} | {rust_result['hash']} |
| {go_result['language']} | {go_result['time']:.2f} | {go_result['ops_per_sec']:,} | {go_result['hash']} |
| {c_result['language']} | {c_result['time']:.2f} | {c_result['ops_per_sec']:,} | {c_result['hash']} |
| {cpp_result['language']} | {cpp_result['time']:.2f} | {cpp_result['ops_per_sec']:,} | {cpp_result['hash']} |

### Performance Summary
- Rust is {(go_result['time'] / rust_result['time'] - 1) * 100:.1f}% faster than Go
- C is {(go_result['time'] / c_result['time'] - 1) * 100:.1f}% faster than Go
- C++ is {(go_result['time'] / cpp_result['time'] - 1) * 100:.1f}% faster than Go
- Final hash: {rust_result['hash']}

---

"""
    
    with open('BenchmarkResult.md', 'a') as f:
        f.write(entry)
    
    print("Result saved to BenchmarkResult.md")

def main():
    print("Running benchmarks...")
    print()
    
    hw_info = get_hardware_info()
    
    rust_result = run_benchmark('./build/SpeedLangX_rust')
    go_result = run_benchmark('./build/SpeedLangX_go')
    c_result = run_benchmark('./build/SpeedLangX_c')
    cpp_result = run_benchmark('./build/SpeedLangX_cpp')
    
    if not rust_result or not go_result or not c_result or not cpp_result:
        print("Error: Failed to run benchmarks")
        sys.exit(1)
    
    # Hardware info table
    hw_data = [
        ['OS', hw_info.get('OS', 'Unknown')],
        ['CPU', hw_info.get('CPU', 'Unknown')],
        ['Memory', hw_info.get('Memory', 'Unknown')]
    ]
    
    print("Hardware Information:")
    print(tabulate(hw_data, headers=['Component', 'Specification'], tablefmt='grid'))
    print()
    
    # Benchmark results table
    results = [
        {
            'Language': rust_result['language'],
            'Time (s)': f"{rust_result['time']:.2f}",
            'Ops/sec': f"{rust_result['ops_per_sec']:,}",
            'Hash': rust_result['hash'][:16] + '...'
        },
        {
            'Language': go_result['language'],
            'Time (s)': f"{go_result['time']:.2f}",
            'Ops/sec': f"{go_result['ops_per_sec']:,}",
            'Hash': go_result['hash'][:16] + '...'
        },
        {
            'Language': c_result['language'],
            'Time (s)': f"{c_result['time']:.2f}",
            'Ops/sec': f"{c_result['ops_per_sec']:,}",
            'Hash': c_result['hash'][:16] + '...'
        },
        {
            'Language': cpp_result['language'],
            'Time (s)': f"{cpp_result['time']:.2f}",
            'Ops/sec': f"{cpp_result['ops_per_sec']:,}",
            'Hash': cpp_result['hash'][:16] + '...'
        }
    ]
    
    print("Benchmark Results:")
    print(tabulate(results, headers='keys', tablefmt='grid'))
    print()
    
    rust_time = rust_result['time']
    go_time = go_result['time']
    c_time = c_result['time']
    cpp_time = cpp_result['time']
    
    print(f"Performance Summary:")
    print(f"  Rust is {(go_time / rust_time - 1) * 100:.1f}% faster than Go")
    print(f"  C is {(go_time / c_time - 1) * 100:.1f}% faster than Go")
    print(f"  C++ is {(go_time / cpp_time - 1) * 100:.1f}% faster than Go")
    print(f"  Final hash: {rust_result['hash']}")
    
    save_result(hw_info, rust_result, go_result, c_result, cpp_result)

if __name__ == '__main__':
    main()
