@echo off
echo ========================================
echo    Creating Microsoft Word Document
echo ========================================
echo.

echo [1/3] Creating basic Word document...
powershell -Command "
try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $doc = $word.Documents.Add()
    
    # Set document properties
    $doc.BuiltInDocumentProperties('Title').Value = 'Gift Box Backend System Documentation'
    $doc.BuiltInDocumentProperties('Author').Value = 'System Implementation Team'
    
    # Add title
    $titleRange = $doc.Range()
    $titleRange.Text = 'Gift Box Backend System - Comprehensive Documentation'
    $titleRange.Font.Name = 'Calibri'
    $titleRange.Font.Size = 18
    $titleRange.Font.Bold = $true
    $titleRange.ParagraphFormat.Alignment = 1
    $titleRange.InsertParagraphAfter()
    $titleRange.InsertParagraphAfter()
    
    # Add subtitle
    $subtitleRange = $doc.Range()
    $subtitleRange.Text = 'Version: 1.0`nDate: October 24, 2025`nAuthor: System Implementation Team'
    $subtitleRange.Font.Name = 'Calibri'
    $subtitleRange.Font.Size = 12
    $subtitleRange.ParagraphFormat.Alignment = 1
    $subtitleRange.InsertParagraphAfter()
    $subtitleRange.InsertParagraphAfter()
    
    # Add Executive Summary
    $summaryTitle = $doc.Range()
    $summaryTitle.Text = '1. Executive Summary'
    $summaryTitle.Font.Name = 'Calibri'
    $summaryTitle.Font.Size = 16
    $summaryTitle.Font.Bold = $true
    $summaryTitle.ParagraphFormat.SpaceAfter = 12
    $summaryTitle.InsertParagraphAfter()
    
    $summaryText = 'The Gift Box Backend System is a comprehensive microservices-based platform designed to handle gift card transactions, user management, merchant operations, and corporate services.'
    $summaryRange = $doc.Range()
    $summaryRange.Text = $summaryText
    $summaryRange.Font.Name = 'Calibri'
    $summaryRange.Font.Size = 11
    $summaryRange.ParagraphFormat.SpaceAfter = 6
    $summaryRange.InsertParagraphAfter()
    
    # Add key features
    $featuresTitle = $doc.Range()
    $featuresTitle.Text = 'Key Features:'
    $featuresTitle.Font.Name = 'Calibri'
    $featuresTitle.Font.Size = 12
    $featuresTitle.Font.Bold = $true
    $featuresTitle.InsertParagraphAfter()
    
    $features = @(
        '• Microservices Architecture: 6 core services with independent scaling',
        '• API Gateway: Nginx-based routing with load balancing and rate limiting',
        '• Database Management: PostgreSQL with Redis caching',
        '• Message Queue: Kafka for asynchronous processing',
        '• Container Orchestration: Docker Compose for deployment',
        '• Security: JWT-based authentication and CORS protection'
    )
    
    foreach ($feature in $features) {
        $featureRange = $doc.Range()
        $featureRange.Text = $feature
        $featureRange.Font.Name = 'Calibri'
        $featureRange.Font.Size = 11
        $featureRange.ParagraphFormat.SpaceAfter = 6
        $featureRange.InsertParagraphAfter()
    }
    
    # Add System Architecture
    $archTitle = $doc.Range()
    $archTitle.Text = '2. System Architecture'
    $archTitle.Font.Name = 'Calibri'
    $archTitle.Font.Size = 16
    $archTitle.Font.Bold = $true
    $archTitle.ParagraphFormat.SpaceAfter = 12
    $archTitle.InsertParagraphAfter()
    
    $archText = 'The system implements modern architectural patterns including API Gateway routing, containerized deployment, and distributed data management.'
    $archRange = $doc.Range()
    $archRange.Text = $archText
    $archRange.Font.Name = 'Calibri'
    $archRange.Font.Size = 11
    $archRange.ParagraphFormat.SpaceAfter = 6
    $archRange.InsertParagraphAfter()
    
    # Add API Gateway section
    $gatewayTitle = $doc.Range()
    $gatewayTitle.Text = '4. API Gateway Implementation'
    $gatewayTitle.Font.Name = 'Calibri'
    $gatewayTitle.Font.Size = 16
    $gatewayTitle.Font.Bold = $true
    $gatewayTitle.ParagraphFormat.SpaceAfter = 12
    $gatewayTitle.InsertParagraphAfter()
    
    $gatewayText = 'The API Gateway is implemented using Nginx with routing to all microservices and security features including CORS, rate limiting, and load balancing.'
    $gatewayRange = $doc.Range()
    $gatewayRange.Text = $gatewayText
    $gatewayRange.Font.Name = 'Calibri'
    $gatewayRange.Font.Size = 11
    $gatewayRange.ParagraphFormat.SpaceAfter = 6
    $gatewayRange.InsertParagraphAfter()
    
    # Add Deployment Guide
    $deployTitle = $doc.Range()
    $deployTitle.Text = '8. Deployment Guide'
    $deployTitle.Font.Name = 'Calibri'
    $deployTitle.Font.Size = 16
    $deployTitle.Font.Bold = $true
    $deployTitle.ParagraphFormat.SpaceAfter = 12
    $deployTitle.InsertParagraphAfter()
    
    $deployText = 'The system can be deployed using Docker Compose with the following steps:'
    $deployRange = $doc.Range()
    $deployRange.Text = $deployText
    $deployRange.Font.Name = 'Calibri'
    $deployRange.Font.Size = 11
    $deployRange.ParagraphFormat.SpaceAfter = 6
    $deployRange.InsertParagraphAfter()
    
    # Add footer
    $footerRange = $doc.Range()
    $footerRange.Text = '`n`n---`n`nDocument Version: 1.0`nLast Updated: October 24, 2025`nNext Review: November 24, 2025'
    $footerRange.Font.Name = 'Calibri'
    $footerRange.Font.Size = 9
    $footerRange.Font.Italic = $true
    $footerRange.ParagraphFormat.Alignment = 1
    
    # Save document
    $fullPath = (Get-Location).Path + '\docs\Gift_Box_Backend_System_Documentation.docx'
    $doc.SaveAs2($fullPath)
    
    # Close document and Word
    $doc.Close()
    $word.Quit()
    
    # Release COM objects
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($doc) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    Write-Host '✓ Successfully created Word document' -ForegroundColor Green
    Write-Host 'Location: ' + $fullPath -ForegroundColor Cyan
} catch {
    Write-Host '✗ Failed to create Word document' -ForegroundColor Red
    Write-Host 'Error: ' + $_.Exception.Message -ForegroundColor Red
    exit 1
}
"

if %errorlevel% equ 0 (
    echo.
    echo [2/3] ✓ Document created successfully!
    echo.
    echo [3/3] ✓ Word document creation completed!
    echo.
    echo The Microsoft Word document has been created at:
    echo %~dp0..\docs\Gift_Box_Backend_System_Documentation.docx
    echo.
    echo You can now open it in Microsoft Word for further editing.
) else (
    echo.
    echo [2/3] ✗ Document creation failed
    echo Please check the error messages above.
)

echo.
pause
