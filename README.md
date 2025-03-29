# Cignore

## A Cursor Ignore Tool

**Automatically generate optimal ignore files for Cursor IDE**  
Keep your workspace clean and improve AI performance by excluding unnecessary files  
*Most of them are automatically excluded but don't you want that peace of mind?*

![Version](https://img.shields.io/badge/Version-1.3.0-green?style=for-the-badge)

## Features ✨

- 🚀 **Smart Auto-Detection** for 30+ project types
- 🤖 **AI-friendly** patterns to optimize token usage
- ⚡ **Lightning-fast** pure Batch implementation
- 🔍 **Custom pattern support** with `add` command

## Installation 📥

1. **Download the script**  
   ```bash
   curl -O https://github.com/Tyaaa-aa/Cignore/blob/f25a2178c033edeabe8bcbab34bb8424e668b085/Cignore/cignore.bat
   ```

2. **Add to Windows PATH**  
   *Recommended for easy access from any location*

   ### GUI Method 🖱️
   1. Create a dedicated folder for the script (e.g., `C:\Tools\cignore\`)
   2. Press `Win + S` and type "environment variables"
   3. Select **"Edit the system environment variables"**
   4. Click **"Environment Variables"** → Under *User variables*, edit `Path`
   5. Click **New** → Add your script path: `C:\Tools\cignore`
   6. Click OK on all windows

   ### Command Line Method ⌨️  
   *(Run as Administrator)*
   ```powershell
   # Temporary PATH (current session)
   $env:Path += ";C:\path\to\cignore\directory"

   # Permanent PATH
   [Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\path\to\cignore", "User")
   ```

3. **Verify Installation**  
   Open a new terminal and run:
   ```bash
   cignore -v
   # Should output: CIGNORE v1.3
   ```

## Usage 🛠️

**Basic Command**  
Generate ignores for current directory:
```bash
cignore
```

**Common Options**  
```bash
# Web project with auto-detection
cignore -w

# Python + AI project
cignore -p -a

# Force all ignore patterns
cignore -all

# Add custom pattern
cignore add "*.tmp"

# Help menu
cignore -h
```

### Command Flags 📌
| Flag       | Description                          |
|------------|--------------------------------------|
| `-auto`    | Auto-detect project type (default)   |
| `-all`     | Include all possible ignore patterns |
| `-w`       | Web development profile              |
| `-p`       | Python profile                       |
| `-g`       | Game development profile             |
| `-a`       | AI/ML profile                        |
| `-d`       | Data science profile                 |
| `-h`       | Show help menu                       |
| `-v`       | Show version                         |

## Auto-Detection 🔍

**Detects these project types:**

| Category       | Technologies                          |
|----------------|---------------------------------------|
| **Web**        | Next.js, Nuxt, Vite, Svelte, Angular  |
| **Mobile**     | React Native, Flutter, Ionic          |
| **Games**      | Unity, Unreal, Godot, Ren'Py         |
| **AI/ML**      | TensorFlow, PyTorch, GGML/GGUF       |
| **Data**       | SQLite, MongoDB, PostgreSQL          |
| **Backend**    | Django, Rails, Laravel, Rust, Go     |

## Troubleshooting 🔧
- **"Command not found"** → Verify PATH contains exact script directory
- **Permission issues** → Right-click `cignore.bat` → Properties → Uncheck "Block"
- **Changes not working** → Restart your terminal after PATH modifications

## Contributing 🤝

Found a bug? Want to add detection for a new project type?

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
