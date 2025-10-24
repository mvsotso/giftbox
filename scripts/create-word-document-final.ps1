# Final Word document creation script
# Creates a comprehensive Word document

param(
    [string]$OutputFile = "docs\Gift_Box_Backend_System_Documentation.docx"
)

Write-Host "========================================" -ForegroundColor Green
Write-Host "   Creating Microsoft Word Document" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Create output directory if it doesn't exist
$outputDir = Split-Path $OutputFile -Parent
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    Write-Host "✓ Created output directory: $outputDir" -ForegroundColor Green
}

try {
    Write-Host "Creating Word document..." -ForegroundColor Yellow
    
    # Create Word application object
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    
    # Create new document
    $doc = $word.Documents.Add()
    
    # Set document properties
    $doc.BuiltInDocumentProperties("Title").Value = "Gift Box Backend System Documentation"
    $doc.BuiltInDocumentProperties("Subject").Value = "Comprehensive system documentation for Gift Box backend implementation"
    $doc.BuiltInDocumentProperties("Author").Value = "System Implementation Team"
    $doc.BuiltInDocumentProperties("Keywords").Value = "Gift Box, Backend, Microservices, API Gateway, Documentation"
    
    # Add title
    $titleRange = $doc.Range()
    $titleRange.Text = "Gift Box Backend System - Comprehensive Documentation"
    $titleRange.Font.Name = "Calibri"
    $titleRange.Font.Size = 18
    $titleRange.Font.Bold = $true
    $titleRange.ParagraphFormat.Alignment = 1  # Center alignment
    $titleRange.InsertParagraphAfter()
    $titleRange.InsertParagraphAfter()
    
    # Add subtitle
    $subtitleRange = $doc.Range()
    $subtitleRange.Text = "Version: 1.0`nDate: October 24, 2025`nAuthor: System Implementation Team"
    $subtitleRange.Font.Name = "Calibri"
    $subtitleRange.Font.Size = 12
    $subtitleRange.ParagraphFormat.Alignment = 1  # Center alignment
    $subtitleRange.InsertParagraphAfter()
    $subtitleRange.InsertParagraphAfter()
    
    # Add table of contents
    $tocRange = $doc.Range()
    $tocRange.Text = "Table of Contents"
    $tocRange.Font.Name = "Calibri"
    $tocRange.Font.Size = 14
    $tocRange.Font.Bold = $true
    $tocRange.InsertParagraphAfter()
    
    $tocItems = @(
        "1. Executive Summary",
        "2. System Architecture", 
        "3. Infrastructure Components",
        "4. API Gateway Implementation",
        "5. Microservices Overview",
        "6. Database Design",
        "7. Security Implementation",
        "8. Deployment Guide",
        "9. Testing Procedures",
        "10. Monitoring and Maintenance",
        "11. Troubleshooting Guide",
        "12. Future Enhancements"
    )
    
    foreach ($item in $tocItems) {
        $tocRange = $doc.Range()
        $tocRange.Text = $item
        $tocRange.Font.Name = "Calibri"
        $tocRange.Font.Size = 11
        $tocRange.InsertParagraphAfter()
    }
    
    $tocRange = $doc.Range()
    $tocRange.InsertParagraphAfter()
    $tocRange.InsertParagraphAfter()
    
    # Add Executive Summary
    $summaryTitle = $doc.Range()
    $summaryTitle.Text = "1. Executive Summary"
    $summaryTitle.Font.Name = "Calibri"
    $summaryTitle.Font.Size = 16
    $summaryTitle.Font.Bold = $true
    $summaryTitle.ParagraphFormat.SpaceAfter = 12
    $summaryTitle.InsertParagraphAfter()
    
    $summaryText = "The Gift Box Backend System is a comprehensive microservices-based platform designed to handle gift card transactions, user management, merchant operations, and corporate services. The system implements modern architectural patterns including API Gateway routing, containerized deployment, and distributed data management."
    
    $summaryRange = $doc.Range()
    $summaryRange.Text = $summaryText
    $summaryRange.Font.Name = "Calibri"
    $summaryRange.Font.Size = 11
    $summaryRange.ParagraphFormat.SpaceAfter = 6
    $summaryRange.InsertParagraphAfter()
    
    # Add key features
    $featuresTitle = $doc.Range()
    $featuresTitle.Text = "Key Features:"
    $featuresTitle.Font.Name = "Calibri"
    $featuresTitle.Font.Size = 12
    $featuresTitle.Font.Bold = $true
    $featuresTitle.InsertParagraphAfter()
    
    $features = @(
        "• Microservices Architecture: 6 core services with independent scaling",
        "• API Gateway: Nginx-based routing with load balancing and rate limiting", 
        "• Database Management: PostgreSQL with Redis caching",
        "• Message Queue: Kafka for asynchronous processing",
        "• Container Orchestration: Docker Compose for deployment",
        "• Security: JWT-based authentication and CORS protection"
    )
    
    foreach ($feature in $features) {
        $featureRange = $doc.Range()
        $featureRange.Text = $feature
        $featureRange.Font.Name = "Calibri"
        $featureRange.Font.Size = 11
        $featureRange.ParagraphFormat.SpaceAfter = 6
        $featureRange.InsertParagraphAfter()
    }
    
    # Add current status
    $statusTitle = $doc.Range()
    $statusTitle.Text = "Current Status:"
    $statusTitle.Font.Name = "Calibri"
    $statusTitle.Font.Size = 12
    $statusTitle.Font.Bold = $true
    $statusTitle.InsertParagraphAfter()
    
    $statusItems = @(
        "• ✅ Infrastructure services deployed and operational",
        "• ✅ API Gateway routing implemented and tested", 
        "• ✅ Test service running successfully",
        "• ⚠️ Microservices deployment pending (JWT library compatibility issues)"
    )
    
    foreach ($status in $statusItems) {
        $statusRange = $doc.Range()
        $statusRange.Text = $status
        $statusRange.Font.Name = "Calibri"
        $statusRange.Font.Size = 11
        $statusRange.ParagraphFormat.SpaceAfter = 6
        $statusRange.InsertParagraphAfter()
    }
    
    # Add System Architecture
    $archTitle = $doc.Range()
    $archTitle.Text = "2. System Architecture"
    $archTitle.Font.Name = "Calibri"
    $archTitle.Font.Size = 16
    $archTitle.Font.Bold = $true
    $archTitle.ParagraphFormat.SpaceAfter = 12
    $archTitle.InsertParagraphAfter()
    
    $archText = "The system implements modern architectural patterns including API Gateway routing, containerized deployment, and distributed data management."
    
    $archRange = $doc.Range()
    $archRange.Text = $archText
    $archRange.Font.Name = "Calibri"
    $archRange.Font.Size = 11
    $archRange.ParagraphFormat.SpaceAfter = 6
    $archRange.InsertParagraphAfter()
    
    # Add technology stack
    $techTitle = $doc.Range()
    $techTitle.Text = "Technology Stack:"
    $techTitle.Font.Name = "Calibri"
    $techTitle.Font.Size = 12
    $techTitle.Font.Bold = $true
    $techTitle.InsertParagraphAfter()
    
    $techItems = @(
        "• API Gateway: Nginx 1.29.2",
        "• Microservices: Spring Boot 2.7.0",
        "• Database: PostgreSQL 15-alpine",
        "• Cache: Redis 7-alpine",
        "• Message Queue: Kafka 7.4.0",
        "• Containerization: Docker with Docker Compose"
    )
    
    foreach ($tech in $techItems) {
        $techRange = $doc.Range()
        $techRange.Text = $tech
        $techRange.Font.Name = "Calibri"
        $techRange.Font.Size = 11
        $techRange.ParagraphFormat.SpaceAfter = 6
        $techRange.InsertParagraphAfter()
    }
    
    # Add API Gateway section
    $gatewayTitle = $doc.Range()
    $gatewayTitle.Text = "4. API Gateway Implementation"
    $gatewayTitle.Font.Name = "Calibri"
    $gatewayTitle.Font.Size = 16
    $gatewayTitle.Font.Bold = $true
    $gatewayTitle.ParagraphFormat.SpaceAfter = 12
    $gatewayTitle.InsertParagraphAfter()
    
    $gatewayText = "The API Gateway is implemented using Nginx with the following features:"
    
    $gatewayRange = $doc.Range()
    $gatewayRange.Text = $gatewayText
    $gatewayRange.Font.Name = "Calibri"
    $gatewayRange.Font.Size = 11
    $gatewayRange.ParagraphFormat.SpaceAfter = 6
    $gatewayRange.InsertParagraphAfter()
    
    # Add routing rules
    $routingTitle = $doc.Range()
    $routingTitle.Text = "Routing Rules:"
    $routingTitle.Font.Name = "Calibri"
    $routingTitle.Font.Size = 12
    $routingTitle.Font.Bold = $true
    $routingTitle.InsertParagraphAfter()
    
    $routingItems = @(
        "• Health Check: /health → Test Service",
        "• User Service: /api/v1/users/* → user-service:8081",
        "• Merchant Service: /api/v1/merchants/* → merchant-service:8082",
        "• Voucher Service: /api/v1/vouchers/* → voucher-service:8083",
        "• Transaction Service: /api/v1/transactions/* → transaction-service:8084",
        "• Payment Service: /api/v1/payments/* → payment-service:8085",
        "• Corporate Service: /api/v1/corporate/* → corporate-service:8086"
    )
    
    foreach ($routing in $routingItems) {
        $routingRange = $doc.Range()
        $routingRange.Text = $routing
        $routingRange.Font.Name = "Calibri"
        $routingRange.Font.Size = 11
        $routingRange.ParagraphFormat.SpaceAfter = 6
        $routingRange.InsertParagraphAfter()
    }
    
    # Add security features
    $securityTitle = $doc.Range()
    $securityTitle.Text = "Security Features:"
    $securityTitle.Font.Name = "Calibri"
    $securityTitle.Font.Size = 12
    $securityTitle.Font.Bold = $true
    $securityTitle.InsertParagraphAfter()
    
    $securityItems = @(
        "• CORS: Cross-origin resource sharing enabled",
        "• Rate Limiting: 10 requests/second with burst capacity",
        "• Load Balancing: Round-robin distribution",
        "• Health Monitoring: Automatic upstream checks"
    )
    
    foreach ($security in $securityItems) {
        $securityRange = $doc.Range()
        $securityRange.Text = $security
        $securityRange.Font.Name = "Calibri"
        $securityRange.Font.Size = 11
        $securityRange.ParagraphFormat.SpaceAfter = 6
        $securityRange.InsertParagraphAfter()
    }
    
    # Add Deployment Guide
    $deployTitle = $doc.Range()
    $deployTitle.Text = "8. Deployment Guide"
    $deployTitle.Font.Name = "Calibri"
    $deployTitle.Font.Size = 16
    $deployTitle.Font.Bold = $true
    $deployTitle.ParagraphFormat.SpaceAfter = 12
    $deployTitle.InsertParagraphAfter()
    
    $deployText = "Prerequisites:"
    $deployRange = $doc.Range()
    $deployRange.Text = $deployText
    $deployRange.Font.Name = "Calibri"
    $deployRange.Font.Size = 12
    $deployRange.Font.Bold = $true
    $deployRange.InsertParagraphAfter()
    
    $deployItems = @(
        "• Docker Desktop installed",
        "• Docker Compose v2.0+",
        "• Minimum 8GB RAM",
        "• 20GB free disk space"
    )
    
    foreach ($deploy in $deployItems) {
        $deployRange = $doc.Range()
        $deployRange.Text = $deploy
        $deployRange.Font.Name = "Calibri"
        $deployRange.Font.Size = 11
        $deployRange.ParagraphFormat.SpaceAfter = 6
        $deployRange.InsertParagraphAfter()
    }
    
    # Add deployment steps
    $stepsTitle = $doc.Range()
    $stepsTitle.Text = "Deployment Steps:"
    $stepsTitle.Font.Name = "Calibri"
    $stepsTitle.Font.Size = 12
    $stepsTitle.Font.Bold = $true
    $stepsTitle.InsertParagraphAfter()
    
    $steps = @(
        "Step 1: Clone Repository",
        "git clone https://github.com/mvsotso/giftbox.git",
        "cd giftbox",
        "",
        "Step 2: Infrastructure Deployment",
        "docker-compose up -d postgres redis zookeeper kafka",
        "",
        "Step 3: API Gateway Deployment",
        "docker-compose up -d nginx-gateway",
        "",
        "Step 4: Test System",
        "curl http://localhost:9080/health"
    )
    
    foreach ($step in $steps) {
        $stepRange = $doc.Range()
        $stepRange.Text = $step
        $stepRange.Font.Name = "Calibri"
        $stepRange.Font.Size = 11
        $stepRange.ParagraphFormat.SpaceAfter = 6
        $stepRange.InsertParagraphAfter()
    }
    
    # Add footer
    $footerRange = $doc.Range()
    $footerRange.Text = "`n`n---`n`nDocument Version: 1.0`nLast Updated: October 24, 2025`nNext Review: November 24, 2025"
    $footerRange.Font.Name = "Calibri"
    $footerRange.Font.Size = 9
    $footerRange.Font.Italic = $true
    $footerRange.ParagraphFormat.Alignment = 1  # Center alignment
    
    Write-Host "Saving document..." -ForegroundColor Yellow
    
    # Save document
    $fullPath = (Resolve-Path $outputDir).Path + "\" + (Split-Path $OutputFile -Leaf)
    $doc.SaveAs2($fullPath)
    
    # Close document and Word
    $doc.Close()
    $word.Quit()
    
    # Release COM objects
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($doc) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Host "✓ Successfully created Word document: $OutputFile" -ForegroundColor Green
    
    # Check if output file was created
    if (Test-Path $fullPath) {
        $fileSize = (Get-Item $fullPath).Length
        Write-Host "✓ Document created successfully" -ForegroundColor Green
        Write-Host "  File size: $([math]::Round($fileSize/1KB, 2)) KB" -ForegroundColor Cyan
        Write-Host "  Location: $fullPath" -ForegroundColor Cyan
    } else {
        Write-Host "✗ Output file was not created" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host "✗ Failed to create Word document" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   Document Creation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "The Microsoft Word document has been created successfully." -ForegroundColor White
Write-Host "You can now open it in Microsoft Word for further editing." -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Open the document in Microsoft Word" -ForegroundColor White
Write-Host "2. Review and format the content as needed" -ForegroundColor White
Write-Host "3. Add any additional sections or details" -ForegroundColor White
Write-Host "4. Save the final document" -ForegroundColor White
