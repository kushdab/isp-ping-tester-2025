# ISP Ping Tester 2025

A lightweight Bash-based benchmarking suite designed to test your local ISP's performance against critical global infrastructure for gaming and streaming.

## Features
- **Multi-Target Benchmarking**: Tests against Riot Games, Valve, Blizzard, Netflix, Twitch, and more.
- **Jitter Calculation**: Measures `mdev` (mean deviation) to identify unstable connections.
- **CSV Logging**: Automatically saves results with timestamps for long-term analysis.
- **Performance Coloring**: Visual cues for low (green), medium (yellow), and high (red) latency.

## Prerequisites
- `bash`
- `ping` (iputils)
- `bc` (for floating point comparisons)

## Usage
1. Make the script executable:
   ```bash
   chmod +x monitor.sh
   ```
2. Run the benchmark:
   ```bash
   ./monitor.sh
   ```

## Targets Included
- **Gaming**: Riot Games (Valorant/League), Valve (CS/Dota), Blizzard.
- **Streaming**: Netflix, Twitch, YouTube Video CDNs.
- **General**: Cloudflare (1.1.1.1), Google DNS (8.8.8.8).

## Output
Results are printed to the terminal and appended to `ping_results_YYYYMMDD.csv`.