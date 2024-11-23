# Define Parameters
param (
    [string]$LogFilePath = "C:\Path\To\LogFile.log", # Path to the log file
    [string]$OutputFilePath = "C:\Path\To\FilteredLogs.txt", # Where to save the filtered log
    [datetime]$StartDate = (Get-Date).AddDays(-7), # Start date for filtering
    [datetime]$EndDate = (Get-Date), # End date for filtering
    [string]$Keyword = "" # Optional keyword to filter by
)

# Function to Analyze Log Files
function Analyze-LogFile {
    param (
        [string]$FilePath,
        [datetime]$StartDate,
        [datetime]$EndDate,
        [string]$Keyword
    )

    Write-Host "Analyzing log file: $FilePath"
    
    # Check if file exists
    if (-Not (Test-Path $FilePath)) {
        Write-Error "Log file does not exist at path: $FilePath"
        return
    }

    # Read log file
    $logEntries = Get-Content $FilePath

    # Filter log entries by date range and keyword
    $filteredLogs = $logEntries | Where-Object {
        ($_ -match '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}') -and `
        ($StartDate -le [datetime]($_.Substring(0, 19)) -and [datetime]($_.Substring(0, 19)) -le $EndDate) -and `
        ($Keyword -eq "" -or $_ -match $Keyword)
    }

    # Output the filtered logs
    return $filteredLogs
}

# Main Script Execution
Write-Host "Starting log analysis..."
try {
    $results = Analyze-LogFile -FilePath $LogFilePath -StartDate $StartDate -EndDate $EndDate -Keyword $Keyword

    if ($results) {
        Write-Host "Filtered log entries found: $($results.Count)"
        
        # Save results to output file
        $results | Out-File -FilePath $OutputFilePath -Encoding UTF8
        Write-Host "Filtered logs saved to: $OutputFilePath"
    } else {
        Write-Host "No log entries matched the criteria."
    }
} catch {
    Write-Error "An error occurred: $_"
}

Write-Host "Log analysis complete."
