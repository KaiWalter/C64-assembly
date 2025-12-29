param (
    [Parameter(Mandatory=$true)]
    [string]$filePath
)

$password = (op item get "C64" --reveal --fields password)
$headers = @{"X-Password"=$password}
$c64hostname = (op item get "C64" --fields hostname)

Invoke-RestMethod -Method POST `
                  -Uri "http://$c64hostname/v1/runners:run_prg" `
                  -InFile $filePath `
                  -Headers $headers `
                  -ContentType "application/octet-stream"