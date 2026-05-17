Write-Output "Checking and updating all Ollama models..."
$models = ollama list | Select-Object -Skip 1 | ForEach-Object { ($_ -split '\s+')[0] }
foreach ($model in $models) {
    Write-Output "-----------------------------------"
    Write-Output "Processing: $model"
    ollama pull $model
}
Write-Output "All local models are up to date!"
