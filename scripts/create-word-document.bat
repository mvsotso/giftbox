@echo off
echo ========================================
echo    Creating Microsoft Word Document
echo ========================================
echo.

echo [1/3] Checking prerequisites...
powershell -Command "Get-Command pandoc -ErrorAction SilentlyContinue" >nul 2>&1
if %errorlevel% neq 0 (
    echo ✗ Pandoc is not installed
    echo.
    echo Please install pandoc from: https://pandoc.org/installing.html
    echo Or install via chocolatey: choco install pandoc
    echo.
    echo Alternative: Use online converter at https://pandoc.org/try/
    pause
    exit /b 1
) else (
    echo ✓ Pandoc is installed
)

echo.
echo [2/3] Converting Markdown to Word document...
powershell -ExecutionPolicy Bypass -File "%~dp0create-word-document.ps1"

if %errorlevel% equ 0 (
    echo.
    echo [3/3] ✓ Document creation completed successfully!
    echo.
    echo The Microsoft Word document has been created at:
    echo %~dp0..\docs\Gift_Box_Backend_System_Documentation.docx
    echo.
    echo You can now open it in Microsoft Word for further editing.
) else (
    echo.
    echo [3/3] ✗ Document creation failed
    echo Please check the error messages above.
)

echo.
pause
