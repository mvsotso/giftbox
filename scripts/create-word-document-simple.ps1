# Simple method to create Word document
# Uses PowerShell COM objects to create Word document

param(
    [string]$InputFile = "docs\Gift_Box_Backend_System_Documentation.md",
    [string]$OutputFile = "docs\Gift_Box_Backend_System_Documentation.docx"
)

Write-Host "========================================" -ForegroundColor Green
Write-Host "   Creating Microsoft Word Document" -ForegroundColor Green
Write-Host "   (Simple Method)" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check if input file exists
if (-not (Test-Path $InputFile)) {
    Write-Host "✗ Input file not found: $InputFile" -ForegroundColor Red
    exit 1
}

Write-Host "Input file: $InputFile" -ForegroundColor Cyan
Write-Host "Output file: $OutputFile" -ForegroundColor Cyan
Write-Host ""

# Create output directory if it doesn't exist
$outputDir = Split-Path $OutputFile -Parent
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    Write-Host "✓ Created output directory: $outputDir" -ForegroundColor Green
}

try {
    Write-Host "Reading Markdown content..." -ForegroundColor Yellow
    
    # Read the markdown file
    $content = Get-Content $InputFile -Raw -Encoding UTF8
    
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
    
    # Add main content sections
    $sections = @(
        @{
            Title = "Executive Summary"
            Content = @(
                "The Gift Box Backend System is a comprehensive microservices-based platform designed to handle gift card transactions, user management, merchant operations, and corporate services.",
                "",
                "Key Features:",
                "• Microservices Architecture: 6 core services with independent scaling",
                "• API Gateway: Nginx-based routing with load balancing and rate limiting", 
                "• Database Management: PostgreSQL with Redis caching",
                "• Message Queue: Kafka for asynchronous processing",
                "• Container Orchestration: Docker Compose for deployment",
                "• Security: JWT-based authentication and CORS protection",
                "",
                "Current Status:",
                "• ✅ Infrastructure services deployed and operational",
                "• ✅ API Gateway routing implemented and tested", 
                "• ✅ Test service running successfully",
                "• ⚠️ Microservices deployment pending (JWT library compatibility issues)"
            )
        },
        @{
            Title = "System Architecture"
            Content = @(
                "The system implements modern architectural patterns including API Gateway routing, containerized deployment, and distributed data management.",
                "",
                "Technology Stack:",
                "• API Gateway: Nginx 1.29.2",
                "• Microservices: Spring Boot 2.7.0",
                "• Database: PostgreSQL 15-alpine",
                "• Cache: Redis 7-alpine",
                "• Message Queue: Kafka 7.4.0",
                "• Containerization: Docker with Docker Compose"
            )
        },
        @{
            Title = "Infrastructure Components"
            Content = @(
                "PostgreSQL Database (Port 5432):",
                "• Purpose: Primary data storage for all microservices",
                "• Status: ✅ Operational",
                "",
                "Redis Cache (Port 6379):",
                "• Purpose: Session storage, caching, and temporary data",
                "• Status: ✅ Operational",
                "",
                "Kafka Message Queue (Ports 9092, 2181):",
                "• Purpose: Asynchronous message processing",
                "• Status: ✅ Operational"
            )
        },
        @{
            Title = "API Gateway Implementation"
            Content = @(
                "The API Gateway is implemented using Nginx with the following features:",
                "",
                "Routing Rules:",
                "• Health Check: /health → Test Service",
                "• User Service: /api/v1/users/* → user-service:8081",
                "• Merchant Service: /api/v1/merchants/* → merchant-service:8082",
                "• Voucher Service: /api/v1/vouchers/* → voucher-service:8083",
                "• Transaction Service: /api/v1/transactions/* → transaction-service:8084",
                "• Payment Service: /api/v1/payments/* → payment-service:8085",
                "• Corporate Service: /api/v1/corporate/* → corporate-service:8086",
                "",
                "Security Features:",
                "• CORS: Cross-origin resource sharing enabled",
                "• Rate Limiting: 10 requests/second with burst capacity",
                "• Load Balancing: Round-robin distribution",
                "• Health Monitoring: Automatic upstream checks"
            )
        },
        @{
            Title = "Microservices Overview"
            Content = @(
                "User Service (Port 8081):",
                "• Purpose: User management and authentication",
                "• Features: JWT-based authentication, password encryption, user session management",
                "",
                "Merchant Service (Port 8082):",
                "• Purpose: Merchant account management",
                "• Features: Merchant verification, store location management, business hours configuration",
                "",
                "Voucher Service (Port 8083):",
                "• Purpose: Gift voucher management",
                "• Features: Voucher generation, QR code integration, expiration tracking",
                "",
                "Transaction Service (Port 8084):",
                "• Purpose: Transaction processing",
                "• Features: Transaction logging, payment integration, history tracking",
                "",
                "Payment Service (Port 8085):",
                "• Purpose: Payment processing",
                "• Features: Multiple payment methods, payment security, transaction encryption",
                "",
                "Corporate Service (Port 8086):",
                "• Purpose: Corporate account management",
                "• Features: Corporate account management, bulk voucher operations, enterprise reporting"
            )
        },
        @{
            Title = "Deployment Guide"
            Content = @(
                "Prerequisites:",
                "• Docker Desktop installed",
                "• Docker Compose v2.0+",
                "• Minimum 8GB RAM",
                "• 20GB free disk space",
                "",
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
        },
        @{
            Title = "Testing Procedures"
            Content = @(
                "1. Unit Testing:",
                "• Service Tests: Individual service functionality",
                "• Integration Tests: Service-to-service communication",
                "• Database Tests: Data persistence and retrieval",
                "",
                "2. Load Testing:",
                "• Performance Tests: Response time measurement",
                "• Stress Tests: High load scenarios",
                "• Concurrency Tests: Multiple user simulation",
                "",
                "3. Security Testing:",
                "• Authentication Tests: Login/logout functionality",
                "• Authorization Tests: Role-based access",
                "• Input Validation: Malicious input handling",
                "",
                "Test Scripts:",
                "• Basic functionality: .\scripts\test-routing.bat",
                "• Comprehensive system: .\scripts\test-gateway-routing.bat"
            )
        },
        @{
            Title = "Troubleshooting Guide"
            Content = @(
                "Common Issues:",
                "",
                "1. Service Connection Issues:",
                "• Problem: Services cannot connect to database",
                "• Solution: Check database status with 'docker-compose ps postgres'",
                "",
                "2. API Gateway Routing Issues:",
                "• Problem: Gateway not routing requests correctly",
                "• Solution: Check nginx configuration and restart gateway",
                "",
                "3. JWT Library Compatibility:",
                "• Problem: Microservices failing to build due to JWT issues",
                "• Solution: Update JWT dependencies in pom.xml files",
                "",
                "4. Memory Issues:",
                "• Problem: Services running out of memory",
                "• Solution: Increase Docker memory limit to 8GB+"
            )
        },
        @{
            Title = "Future Enhancements"
            Content = @(
                "Phase 1: Performance Optimization",
                "• Caching Strategy: Advanced Redis caching",
                "• Database Optimization: Query optimization and indexing",
                "• Load Balancing: Multiple service instances",
                "",
                "Phase 2: Security Enhancements",
                "• OAuth 2.0: Advanced authentication",
                "• API Rate Limiting: Advanced rate limiting strategies",
                "• Audit Logging: Comprehensive audit trails",
                "",
                "Phase 3: Scalability",
                "• Kubernetes: Container orchestration",
                "• Service Mesh: Istio implementation",
                "• Auto-scaling: Dynamic resource allocation",
                "",
                "Phase 4: Advanced Features",
                "• Real-time Analytics: Live data processing",
                "• Machine Learning: Predictive analytics",
                "• Mobile SDK: Native mobile integration"
            )
        }
    )
    
    # Add each section
    foreach ($section in $sections) {
        # Add section title
        $titleRange = $doc.Range()
        $titleRange.Text = $section.Title
        $titleRange.Font.Name = "Calibri"
        $titleRange.Font.Size = 16
        $titleRange.Font.Bold = $true
        $titleRange.ParagraphFormat.SpaceAfter = 12
        $titleRange.InsertParagraphAfter()
        
        # Add section content
        foreach ($line in $section.Content) {
            $contentRange = $doc.Range()
            $contentRange.Text = $line
            $contentRange.Font.Name = "Calibri"
            $contentRange.Font.Size = 11
            $contentRange.ParagraphFormat.SpaceAfter = 6
            $contentRange.InsertParagraphAfter()
        }
        
        # Add space between sections
        $spaceRange = $doc.Range()
        $spaceRange.InsertParagraphAfter()
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
