@echo off
setlocal enabledelayedexpansion

:: ANSI Color Codes (Windows 10+)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "CYAN=[96m"
set "MAG=[95m"
set "RESET=[0m"

:: Check for add command
if "%~1"=="add" (
    call :add_ignore %~2 %~3
    exit /b %errorlevel%
)

:: Initialize modes
set "AUTO_MODE=1"
set "ALL_MODE=0"
set "WEB_MODE=0"
set "PYTHON_MODE=0"
set "GAME_MODE=0"
set "AI_MODE=0"
set "DATA_MODE=0"
set "MOBILE_MODE=0"
set "BACKEND_MODE=0"

:: Parse arguments
set "TARGET_DIR=."
:argloop
if "%~1" neq "" (
    if "%~1"=="-w" (
        set "WEB_MODE=1"
        set "AUTO_MODE=0"
        set "ALL_MODE=0"
    ) else if "%~1"=="-p" (
        set "PYTHON_MODE=1"
        set "AUTO_MODE=0"
        set "ALL_MODE=0"
    ) else if "%~1"=="-g" (
        set "GAME_MODE=1"
        set "AUTO_MODE=0"
        set "ALL_MODE=0"
    ) else if "%~1"=="-a" (
        set "AI_MODE=1"
        set "AUTO_MODE=0"
        set "ALL_MODE=0"
    ) else if "%~1"=="-d" (
        set "DATA_MODE=1"
        set "AUTO_MODE=0"
        set "ALL_MODE=0"
    ) else if "%~1"=="-auto" (
        set "AUTO_MODE=1"
        set "ALL_MODE=0"
    ) else if "%~1"=="-all" (
        set "ALL_MODE=1"
        set "AUTO_MODE=0"
    ) else if "%~1"=="-h" (
        call :show_help
        exit /b 0
    ) else if "%~1"=="-v" (
        echo CIGNORE v1.3
        exit /b 0
    ) else if "%~1"=="." (
        set "TARGET_DIR=%CD%"
    ) else (
        set "TARGET_DIR=%~f1"
    )
    shift
    goto :argloop
)

:: Validate directory
cd /d "%TARGET_DIR%" 2>nul || (
    echo %RED%[X] Error: Invalid directory%RESET%
    exit /b 1
)

:: Check write permissions
echo test > "%TARGET_DIR%\.cursorignore.test" 2>nul
if %errorlevel% neq 0 (
    echo %RED%[X] Write permission denied in directory%RESET%
    del "%TARGET_DIR%\.cursorignore.test" 2>nul
    exit /b 1
)
del "%TARGET_DIR%\.cursorignore.test" 2>nul

:: Get actual folder name
for %%a in ("%CD%") do set "DISPLAY_NAME=%%~nxa"

:: Auto-detection
if %AUTO_MODE%==1 (
    echo %CYAN%[~] Auto-detecting project type...%RESET%
    
    :: Reset modes
    set "WEB_MODE=0"
    set "PYTHON_MODE=0"
    set "GAME_MODE=0"
    set "AI_MODE=0"
    set "MOBILE_MODE=0"
    set "BACKEND_MODE=0"

    :: Web Frameworks
    if exist "next.config.*" (
        echo %YELLOW%[Next.js]%RESET%
        set "WEB_MODE=1"
    )
    if exist "nuxt.config.*" (
        echo %YELLOW%[Nuxt.js]%RESET%
        set "WEB_MODE=1"
    )
    if exist "vite.config.*" (
        echo %YELLOW%[Vite]%RESET%
        set "WEB_MODE=1"
    )
    if exist "astro.config.*" (
        echo %YELLOW%[Astro]%RESET%
        set "WEB_MODE=1"
    )
    if exist "svelte.config.*" (
        echo %YELLOW%[SvelteKit]%RESET%
        set "WEB_MODE=1"
    )
    if exist "angular.json" (
        echo %YELLOW%[Angular]%RESET%
        set "WEB_MODE=1"
    )
    if exist "src/main.jsx" (
        echo %YELLOW%[React]%RESET%
        set "WEB_MODE=1"
    )
    if exist "src/main.tsx" (
        echo %YELLOW%[React]%RESET%
        set "WEB_MODE=1"
    )
    if exist "src/App.jsx" (
        echo %YELLOW%[React]%RESET%
        set "WEB_MODE=1"
    )
    if exist "src/App.tsx" (
        echo %YELLOW%[React]%RESET%
        set "WEB_MODE=1"
    )
    if exist "vue.config.*" (
        echo %YELLOW%[Vue CLI]%RESET%
        set "WEB_MODE=1"
    )

    :: Mobile
    if exist "android" (
        echo %YELLOW%[Android]%RESET%
        set "MOBILE_MODE=1"
    )
    if exist "ios" (
        echo %YELLOW%[iOS]%RESET%
        set "MOBILE_MODE=1"
    )
    if exist "pubspec.yaml" (
        echo %YELLOW%[Flutter]%RESET%
        set "MOBILE_MODE=1"
    )
    if exist "ionic.config.json" (
        echo %YELLOW%[Ionic]%RESET%
        set "MOBILE_MODE=1"
    )
    if exist "ios/Podfile" (
        echo %YELLOW%[iOS Native]%RESET%
        set "MOBILE_MODE=1"
    )
    if exist "build.gradle" (
        echo %YELLOW%[Android Native]%RESET%
        set "MOBILE_MODE=1"
    )

    :: Game Dev
    if exist "Assets" (
        echo %YELLOW%[Unity]%RESET%
        set "GAME_MODE=1"
    )
    if exist "ProjectSettings" (
        echo %YELLOW%[Unity]%RESET%
        set "GAME_MODE=1"
    )
    if exist "*.uproject" (
        echo %YELLOW%[Unreal Engine]%RESET%
        set "GAME_MODE=1"
    )
    if exist "project.godot" (
        echo %YELLOW%[Godot]%RESET%
        set "GAME_MODE=1"
    )
    if exist "game" (
        echo %YELLOW%[Ren'Py]%RESET%
        set "GAME_MODE=1"
    )
    if exist "scripts" (
        echo %YELLOW%[Ren'Py]%RESET%
        set "GAME_MODE=1"
    )

    :: Backend
    if exist "requirements.txt" (
        echo %YELLOW%[Python]%RESET%
        set "PYTHON_MODE=1"
    )
    if exist "package.json" (
        findstr /i "\<express\>" "package.json" >nul && (
            echo %YELLOW%[Express.js]%RESET%
            set "BACKEND_MODE=1"
        )
    )
    if exist "manage.py" (
        echo %YELLOW%[Django]%RESET%
        set "BACKEND_MODE=1"
    )
    if exist "Gemfile" (
        echo %YELLOW%[Rails]%RESET%
        set "BACKEND_MODE=1"
    )
    if exist "composer.json" (
        echo %YELLOW%[Laravel]%RESET%
        set "BACKEND_MODE=1"
    )
    if exist "pom.xml" (
        echo %YELLOW%[Maven]%RESET%
        set "BACKEND_MODE=1"
    )
    if exist "Dockerfile" (
        echo %YELLOW%[Docker]%RESET%
        set "BACKEND_MODE=1"
    )
    if exist "Cargo.toml" (
        echo %YELLOW%[Rust]%RESET%
        set "BACKEND_MODE=1"
    )
    if exist "go.mod" (
        echo %YELLOW%[Go]%RESET%
        set "BACKEND_MODE=1"
    )

    :: AI/ML
    dir /b *.gguf *.bin *.h5 *.pth *.joblib 2>nul && (
        echo %YELLOW%[ML Models]%RESET%
        set "AI_MODE=1"
    )
    if exist "requirements.txt" (
        findstr /i "\<tensorflow\> \<keras\> \<torch\>" "requirements.txt" >nul && (
            echo %YELLOW%[ML Framework]%RESET%
            set "AI_MODE=1"
        )
    )

    :: Data
    if exist "*.db" (
        echo %YELLOW%[SQLite]%RESET%
        set "DATA_MODE=1"
    )
    if exist "mongod.conf" (
        echo %YELLOW%[MongoDB]%RESET%
        set "DATA_MODE=1"
    )
    if exist "postgresql.conf" (
        echo %YELLOW%[PostgreSQL]%RESET%
        set "DATA_MODE=1"
    )
)

:: Build profile display
set "PROFILES="
if %ALL_MODE%==1 set "PROFILES=!PROFILES!ALL "
if %AUTO_MODE%==1 set "PROFILES=!PROFILES!AUTO "
if %WEB_MODE%==1 set "PROFILES=!PROFILES!WEB "
if %PYTHON_MODE%==1 set "PROFILES=!PROFILES!PYTHON "
if %GAME_MODE%==1 set "PROFILES=!PROFILES!GAME "
if %AI_MODE%==1 set "PROFILES=!PROFILES!AI/ML "
if %DATA_MODE%==1 set "PROFILES=!PROFILES!DATA_SCI "
if %MOBILE_MODE%==1 set "PROFILES=!PROFILES!MOBILE "
if %BACKEND_MODE%==1 set "PROFILES=!PROFILES!BACKEND "

:: Display header
echo %CYAN%[*] Configuring ignores for: !DISPLAY_NAME!%RESET%
echo %MAG%Profiles: !PROFILES:~0,-1!%RESET%
echo.

:: Create files
call :create_file ".cursorignore"
call :create_file ".cursorindexingignore"

echo.
echo %GREEN%[+] Configuration complete!%RESET%
exit /b 0

:create_file
set "FILE=%~1"
echo %CYAN%[~] Generating %FILE%%RESET%

(
    echo # Generated by Cursor Ignore
    echo # Date: %date% %time%
    echo.
    
    echo # ===== System Files =====
    echo .DS_Store
    echo Thumbs.db
    echo desktop.ini
    echo.
    
    echo # ===== General Development =====
    echo .git
    echo .history
    echo .env
    echo .env*
    echo .env.*
    echo .svn
    echo .vscode
    echo .idea
    echo node_modules
    echo dist
    echo build
    echo *.log
    echo *.bak
    echo .cache/
    echo .output/
    echo *.lock
    echo *.tmp
    echo.
    
    if !WEB_MODE!==1 (
        echo # ===== Web Development =====
        echo .next
        echo .nuxt
        echo .svelte-kit
        echo .astro
        echo public/
        echo .cache/
        echo .output/
        echo *.lock
        echo bun.lockb
        echo yarn.lock
        echo .yarn
        echo .pnp
        echo .pnp.js/
        echo .pnp/
        echo.
    )
    
    if !MOBILE_MODE!==1 (
        echo # ===== Mobile Development =====
        echo ios/Pods/
        echo android/.gradle/
        echo build/
        echo .dart_tool/
        echo .flutter-plugins
        echo.
    )
    
    if !BACKEND_MODE!==1 (
        echo # ===== Backend Services =====
        echo venv/
        echo .mvn/
        echo target/
        echo bin/
        echo __pycache__/
        echo.
    )
    
    if !PYTHON_MODE!==1 (
        echo # ===== Python =====
        echo __pycache__
        echo .venv
        echo .mypy_cache
        echo *.pyc
        echo .coverage
        echo.
    )
    
    if !GAME_MODE!==1 (
        echo # ===== Game Development =====
        echo Library/
        echo Temp/
        echo Build/
        echo Binaries/
        echo DerivedDataCache/
        echo.
    )
    
    if !AI_MODE!==1 (
        echo # ===== AI/ML =====
        echo *.pt
        echo *.onnx
        echo *.gguf
        echo *.bin
        echo *.tflite
        echo.
    )
    
    if !DATA_MODE!==1 (
        echo # ===== Data Science =====
        echo *.ipynb_checkpoints
        echo *.hdf5
        echo *.parquet
        echo .ipython/
        echo .jupyter/
        echo.
    )
    
    if !ALL_MODE!==1 (
        echo # ===== Additional Defaults =====
        echo *.zip
        echo *.tar
        echo *.gz
        echo *.pdf
        echo.
    )
) > "%FILE%"

echo %GREEN%[+] %FILE% updated%RESET%
goto :eof

:add_ignore
if "%~1"=="" (
    echo %RED%[X] Missing pattern to add%RESET%
    echo Usage: cignore add <pattern> [directory]
    exit /b 1
)

set "ADD_PATH=%~1"
set "TARGET_DIR=%~f2"
if "!TARGET_DIR!"=="" set "TARGET_DIR=%CD%"

echo %CYAN%[~] Adding '!ADD_PATH!' to ignores in: !TARGET_DIR!%RESET%

cd /d "!TARGET_DIR!" 2>nul || (
    echo %RED%[X] Invalid directory%RESET%
    exit /b 1
)

:: Create files if missing
if not exist ".cursorignore" type nul > ".cursorignore"
if not exist ".cursorindexingignore" type nul > ".cursorindexingignore"

:: Check duplicates
findstr /x /c:"!ADD_PATH!" ".cursorignore" >nul && (
    echo %YELLOW%[!] Exists in .cursorignore%RESET%
)
findstr /x /c:"!ADD_PATH!" ".cursorindexingignore" >nul && (
    echo %YELLOW%[!] Exists in .cursorindexingignore%RESET%
)

>> .cursorignore echo !ADD_PATH!
>> .cursorindexingignore echo !ADD_PATH!

echo %GREEN%[+] Added to both ignore files%RESET%
exit /b 0

:show_help
echo %CYAN%
echo CIGNORE v1.3
echo ============
echo Usage: 
echo   cignore [directory] [options]  
echo   cignore add ^<pattern^> [dir]
echo.
echo Options:
echo  -auto  Auto-detect (default)  
echo  -all   All patterns           
echo  -w     Web Development        
echo  -p     Python                 
echo  -g     Game Development       
echo  -a     AI/ML                  
echo  -d     Data Science           
echo  -v     Version                
echo  -h     Help                   
echo.
echo Detectable Projects:
echo  Web: Next, Nuxt, Vite, Svelte, Angular, React, Vue
echo  Mobile: React Native, Flutter, Ionic, iOS, Android
echo  Games: Unity, Unreal, Godot, Ren'Py
echo  AI: TensorFlow, PyTorch, GGUF models
echo  Data: SQLite, MongoDB, PostgreSQL
echo  Backend: Django, Rails, Laravel, Docker, Rust, Go
echo %RESET%
goto :eof