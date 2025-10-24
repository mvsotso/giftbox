# Fix APISIX Routes Script
Write-Host "========================================"
Write-Host "    Fixing APISIX Routes"
Write-Host "========================================"
Write-Host ""

# Wait for APISIX to be ready
Write-Host "Waiting for APISIX to be ready..."
Start-Sleep -Seconds 10

# Test Admin API
Write-Host "Testing Admin API..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9180/apisix/admin/routes" -Headers @{"X-API-KEY" = "edd1c9f034335f136f87ad84b625c8f1"} -Method GET
    Write-Host "✓ Admin API is accessible"
} catch {
    Write-Host "✗ Admin API not accessible: $($_.Exception.Message)"
    Write-Host "Trying alternative approach..."
}

# Create Health Route
Write-Host ""
Write-Host "Creating Health Route..."
$healthRoute = @{
    uri = "/health"
    upstream = @{
        type = "roundrobin"
        nodes = @{
            "test-service:8080" = 1
        }
    }
} | ConvertTo-Json -Depth 3

try {
    $response = Invoke-WebRequest -Uri "http://localhost:9180/apisix/admin/routes/1" -Headers @{"X-API-KEY" = "edd1c9f034335f136f87ad84b625c8f1"} -Method PUT -Body $healthRoute -ContentType "application/json"
    Write-Host "✓ Health route created"
} catch {
    Write-Host "✗ Failed to create health route: $($_.Exception.Message)"
}

# Create Root Route
Write-Host ""
Write-Host "Creating Root Route..."
$rootRoute = @{
    uri = "/"
    upstream = @{
        type = "roundrobin"
        nodes = @{
            "test-service:8080" = 1
        }
    }
} | ConvertTo-Json -Depth 3

try {
    $response = Invoke-WebRequest -Uri "http://localhost:9180/apisix/admin/routes/2" -Headers @{"X-API-KEY" = "edd1c9f034335f136f87ad84b625c8f1"} -Method PUT -Body $rootRoute -ContentType "application/json"
    Write-Host "✓ Root route created"
} catch {
    Write-Host "✗ Failed to create root route: $($_.Exception.Message)"
}

# Test Routes
Write-Host ""
Write-Host "========================================"
Write-Host "    Testing Routes"
Write-Host "========================================"

Write-Host ""
Write-Host "Testing Health Route..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9080/health" -Method GET
    Write-Host "✓ Health route working: $($response.Content)"
} catch {
    Write-Host "✗ Health route failed: $($_.Exception.Message)"
}

Write-Host ""
Write-Host "Testing Root Route..."
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9080/" -Method GET
    Write-Host "✓ Root route working: $($response.Content)"
} catch {
    Write-Host "✗ Root route failed: $($_.Exception.Message)"
}

Write-Host ""
Write-Host "APISIX configuration complete!"
