#!/bin/bash

# Replace these variables with your Recorded Future API credentials
API_KEY="your_api_key_here"
API_ENDPOINT="https://api.recordedfuture.com/v2/alert/search"

# Function to fetch alerts from Recorded Future API
fetch_alerts() {
    response=$(curl -s -X GET "$API_ENDPOINT" \
        -H "X-RFToken: $API_KEY" \
        -H "Accept: application/json")
    
    echo "$response"
}

# Fetch and process alerts
process_alerts() {
    response=$(fetch_alerts)

    # Check if the response is valid JSON
    if ! jq -e . >/dev/null 2>&1 <<<"$response"; then
        echo "Error: Invalid response from API."
        exit 1
    fi

    # Parse and display alerts
    alerts=$(echo "$response" | jq -r '.data.items[] | {id: .id, title: .title, description: .description, riskScore: .risk.score}')
    echo "Recorded Future Alerts:"
    echo "$alerts" | jq -r '. | "ID: \(.id)\nTitle: \(.title)\nDescription: \(.description)\nRisk Score: \(.riskScore)\n"'
}

# Main function
main() {
    process_alerts
}

# Execute main function
main
