# PowerShell script to create Microsoft Word document from Markdown
# Requires pandoc to be installed

param(
    [string]$InputFile = "docs\Gift_Box_Backend_System_Documentation.md",
    [string]$OutputFile = "docs\Gift_Box_Backend_System_Documentation.docx"
)

Write-Host "========================================" -ForegroundColor Green
Write-Host "   Creating Microsoft Word Document" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check if pandoc is installed
try {
    $pandocVersion = pandoc --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Pandoc is installed" -ForegroundColor Green
    } else {
        throw "Pandoc not found"
    }
} catch {
    Write-Host "✗ Pandoc is not installed" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install pandoc from: https://pandoc.org/installing.html" -ForegroundColor Yellow
    Write-Host "Or install via chocolatey: choco install pandoc" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Alternative: Use online converter at https://pandoc.org/try/" -ForegroundColor Yellow
    exit 1
}

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

# Convert markdown to Word document
Write-Host "Converting Markdown to Word document..." -ForegroundColor Yellow

try {
    pandoc $InputFile -o $OutputFile --reference-doc=docs\reference.docx 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Successfully created Word document: $OutputFile" -ForegroundColor Green
    } else {
        throw "Pandoc conversion failed"
    }
} catch {
    Write-Host "✗ Failed to convert document" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Check if output file was created
if (Test-Path $OutputFile) {
    $fileSize = (Get-Item $OutputFile).Length
    Write-Host "✓ Document created successfully" -ForegroundColor Green
    Write-Host "  File size: $([math]::Round($fileSize/1KB, 2)) KB" -ForegroundColor Cyan
    Write-Host "  Location: $((Get-Item $OutputFile).FullName)" -ForegroundColor Cyan
} else {
    Write-Host "✗ Output file was not created" -ForegroundColor Red
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
