#!/usr/bin/env bash

# HTTP client benchmark script: curl vs xh vs curlie
# 
# Results (2025/11/17 17:27:XX)
# =======
#
# Average Times:
#   curl:    0.821s
#   xh:      0.954s
#   curlie:  0.834s
#
# Points (by rank):
#   curlie:  23.25 points
#   curl:    22.25 points
#   xh:      11.50 points
#
# Overall Winner: curlie (0.834s average, 23.250 points)

# Define clients to benchmark (just add additional clients to this list)
clients=("curl" "xh" "curlie")

endpoints=(
    # Weather and geo services
    "https://v2d.wttr.in"
    "https://api.ipify.org"

    # Code hosting and APIs
    "https://api.github.com"
    "https://api.github.com/users/octocat"
    "https://gitlab.com/api/v4/projects"

    # Test/demo endpoints
    "https://httpbin.org/get"
    "https://httpbin.org/json"
    "https://jsonplaceholder.typicode.com/posts/1"
    "https://jsonplaceholder.typicode.com/users"
    "https://dummyjson.com/products/1"

    # General websites
    "https://www.google.com"
    "https://example.com"
    "https://www.wikipedia.org"

    # CDNs and static content
    "https://cdn.jsdelivr.net/npm/vue@3"
    "https://unpkg.com/react@18/package.json"

    # Popular APIs
    "https://api.spacexdata.com/v4/launches/latest"
    "https://catfact.ninja/fact"
    "https://dog.ceo/api/breeds/list/all"
    "https://randomuser.me/api/"
)

runs=5

echo "HTTP Client Benchmark: curl vs xh vs curlie"
echo "======================================================="
echo "Runs per endpoint: $runs"
echo ""

results_file="/tmp/benchmark_results_$$.txt"
> "$results_file"

echo "Running benchmarks..."
echo ""

# Function to benchmark a client
benchmark_client() {
    local client=$1
    local endpoint=$2
    local runs=$3
    local total=0

    for i in $(seq 1 $runs); do
        start=$(python3 -c 'import time; print("%.9f" % time.time())')

        case $client in
            curl)
                curl -s "$endpoint" > /dev/null 2>&1
                ;;
            xh)
                xh "$endpoint" > /dev/null 2>&1
                ;;
            curlie)
                curlie -s "$endpoint" > /dev/null 2>&1
                ;;
        esac

        end=$(python3 -c 'import time; print("%.9f" % time.time())')
        elapsed=$(echo "$end - $start" | bc -l)
        total=$(echo "$total + $elapsed" | bc -l)
    done

    printf "%.3f" $(echo "scale=3; $total / $runs" | bc -l)
}

for endpoint in "${endpoints[@]}"; do
    # Skip comments
    [[ "$endpoint" =~ ^#.*$ ]] && continue

    echo "Testing: $endpoint"

    # Warm up
    curl -s "$endpoint" > /dev/null 2>&1
    xh "$endpoint" > /dev/null 2>&1
    curlie -s "$endpoint" > /dev/null 2>&1

    # Benchmark each client and build result line
    result_line="$endpoint"
    for client in "${clients[@]}"; do
        avg=$(benchmark_client "$client" "$endpoint" "$runs")
        result_line="$result_line|$avg"
    done
    echo "$result_line" >> "$results_file"

    echo "  ✓ Completed"
done

echo ""
echo "Results"
echo "======="
echo ""

# Initialize accumulators
declare -A client_sum
declare -A client_points
for client in "${clients[@]}"; do
    client_sum[$client]=0
    client_points[$client]=0
done
count=0

# Process each result
while IFS='|' read -r endpoint curl_time xh_time curlie_time; do
    # Add to sums
    client_sum[curl]=$(echo "${client_sum[curl]} + $curl_time" | bc -l)
    client_sum[xh]=$(echo "${client_sum[xh]} + $xh_time" | bc -l)
    client_sum[curlie]=$(echo "${client_sum[curlie]} + $curlie_time" | bc -l)

    # Create array of time:client pairs for sorting
    time_client_pairs=("$curl_time:curl" "$xh_time:xh" "$curlie_time:curlie")
    IFS=$'\n' sorted_pairs=($(printf '%s\n' "${time_client_pairs[@]}" | sort -n))
    unset IFS

    # Calculate point values based on number of clients
    num_clients=${#clients[@]}
    point_values=()
    for ((i=0; i<num_clients; i++)); do
        point_values[$i]=$(echo "scale=3; 1.5 - $i * 0.5" | bc -l)
    done

    # Group by time to handle ties
    position=0
    i=0
    while [ $i -lt ${#sorted_pairs[@]} ]; do
        current_time="${sorted_pairs[$i]%%:*}"
        tied_clients=()

        # Find all clients with same time
        j=$i
        while [ $j -lt ${#sorted_pairs[@]} ] && [ "${sorted_pairs[$j]%%:*}" = "$current_time" ]; do
            tied_clients+=("${sorted_pairs[$j]##*:}")
            j=$((j + 1))
        done

        num_tied=${#tied_clients[@]}

        # Calculate average points for tied positions
        total_points=0
        for ((k=0; k<num_tied; k++)); do
            total_points=$(echo "$total_points + ${point_values[$((position + k))]}" | bc -l)
        done
        avg_points=$(echo "scale=3; $total_points / $num_tied" | bc -l)

        # Assign points to tied clients
        for client in "${tied_clients[@]}"; do
            client_points[$client]=$(echo "${client_points[$client]} + $avg_points" | bc -l)
        done

        position=$((position + num_tied))
        i=$j
    done

    count=$((count + 1))
done < "$results_file"

# Calculate averages
declare -A client_avg
for client in "${clients[@]}"; do
    client_avg[$client]=$(printf "%.3f" $(echo "scale=3; ${client_sum[$client]} / $count" | bc -l))
done

echo "Average Times:"
for client in "${clients[@]}"; do
    printf "  %-8s %.3fs\n" "$client:" "${client_avg[$client]}"
done

echo ""
echo "Points (by rank):"

# Sort clients by points (descending)
declare -a points_ranking
for client in "${clients[@]}"; do
    points_ranking+=("${client_points[$client]}:$client")
done
IFS=$'\n' points_ranking=($(sort -rn <<<"${points_ranking[*]}"))
unset IFS

for entry in "${points_ranking[@]}"; do
    points="${entry%%:*}"
    client="${entry##*:}"
    printf "  %-8s %.2f points\n" "$client:" "$points"
done

# Determine overall winner (highest points)
winner_entry="${points_ranking[0]}"
winner_points="${winner_entry%%:*}"
winner_client="${winner_entry##*:}"

echo ""
echo "Overall Winner: $winner_client (${client_avg[$winner_client]}s average, $winner_points points)"

rm -f "$results_file"
