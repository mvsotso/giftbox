# Alternative method to create Word document without Pandoc
# Uses PowerShell COM objects to create Word document

param(
    [string]$InputFile = "docs\Gift_Box_Backend_System_Documentation.md",
    [string]$OutputFile = "docs\Gift_Box_Backend_System_Documentation.docx"
)

Write-Host "========================================" -ForegroundColor Green
Write-Host "   Creating Microsoft Word Document" -ForegroundColor Green
Write-Host "   (Alternative Method)" -ForegroundColor Green
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
    
    # Process markdown content
    $lines = $content -split "`n"
    $currentSection = ""
    
    foreach ($line in $lines) {
        $line = $line.Trim()
        
        if ($line -match "^# (.+)") {
            # Main heading
            $headingRange = $doc.Range()
            $headingRange.Text = $matches[1]
            $headingRange.Font.Name = "Calibri"
            $headingRange.Font.Size = 16
            $headingRange.Font.Bold = $true
            $headingRange.ParagraphFormat.SpaceAfter = 12
            $headingRange.InsertParagraphAfter()
            $currentSection = $matches[1]
            
        } elseif ($line -match "^## (.+)") {
            # Subheading
            $subheadingRange = $doc.Range()
            $subheadingRange.Text = $matches[1]
            $subheadingRange.Font.Name = "Calibri"
            $subheadingRange.Font.Size = 14
            $subheadingRange.Font.Bold = $true
            $subheadingRange.ParagraphFormat.SpaceAfter = 6
            $subheadingRange.InsertParagraphAfter()
            
        } elseif ($line -match "^### (.+)") {
            # Sub-subheading
            $subsubheadingRange = $doc.Range()
            $subsubheadingRange.Text = $matches[1]
            $subsubheadingRange.Font.Name = "Calibri"
            $subsubheadingRange.Font.Size = 12
            $subsubheadingRange.Font.Bold = $true
            $subsubheadingRange.ParagraphFormat.SpaceAfter = 3
            $subsubheadingRange.InsertParagraphAfter()
            
        } elseif ($line -match "^- (.+)") {
            # Bullet point
            $bulletRange = $doc.Range()
            $bulletRange.Text = "• " + $matches[1]
            $bulletRange.Font.Name = "Calibri"
            $bulletRange.Font.Size = 11
            $bulletRange.ParagraphFormat.LeftIndent = 18
            $bulletRange.InsertParagraphAfter()
            
        } elseif ($line -match "^\d+\. (.+)") {
            # Numbered list
            $numberedRange = $doc.Range()
            $numberedRange.Text = $line
            $numberedRange.Font.Name = "Calibri"
            $numberedRange.Font.Size = 11
            $numberedRange.ParagraphFormat.LeftIndent = 18
            $numberedRange.InsertParagraphAfter()
            
        } elseif ($line -match "^\|(.+)\|$") {
            # Table row
            $tableRange = $doc.Range()
            $tableRange.Text = $line
            $tableRange.Font.Name = "Calibri"
            $tableRange.Font.Size = 10
            $tableRange.InsertParagraphAfter()
            
        } elseif ($line -match "^```") {
            # Code block start/end
            $codeRange = $doc.Range()
            $codeRange.Text = $line
            $codeRange.Font.Name = "Consolas"
            $codeRange.Font.Size = 9
            $codeRange.Font.Color = 0x800000  # Dark red
            $codeRange.InsertParagraphAfter()
            
        } elseif ($line.Length -gt 0) {
            # Regular paragraph
            $paraRange = $doc.Range()
            $paraRange.Text = $line
            $paraRange.Font.Name = "Calibri"
            $paraRange.Font.Size = 11
            $paraRange.ParagraphFormat.SpaceAfter = 6
            $paraRange.InsertParagraphAfter()
        }
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
