# Windows Sandbox Dev Environment Setup

You have two ways to set up the development environment in Windows Sandbox. Choose the one that best fits your needs:

---

## 🟢 Option 1 – Easiest: Use `vscode-aspire.wsb`

This is the **simplest method**.

- This uses the official [.NET installer guide](https://dotnet.microsoft.com/en-us/learn/dotnet/hello-world-tutorial/install) and installs components using `dotnet.winget`.
- After the Sandbox starts, **wait a few minutes**. A command prompt will eventually appear asking you to confirm installation of the components.
- No setup required on the host machine.

Open the `vscode-aspire.wsb` and update the `HostFolder` path to match the full path on your machine:

The default value for `HostFolder` is.

```xml
<HostFolder>C:\data\mycode\sayedha-sandbox\mapped-folder</HostFolder>
```

The `HostFolder` path **must be absolute** — relative paths are not supported by `.wsb` files.

Double click `vscode-aspire.wsb` to create the sandbox. When it starts a PowerShell window will appear,
press Enter when prompted. After a few minutes you will need to confirm the installation components.

### ⚠️ Note:
This option downloads files **every time**, so it may be slower if you run it often.

---

## ⚡ Option 2 – Faster for Reuse: Use `vscode-aspire-install-from-host.wsb`

This method downloads all tools once on the host and reuses them each time you launch Sandbox. Recommended if you'll run it multiple times.

### ✅ Step 1: Download Tools on the Host

Run this PowerShell script to download all necessary installers into the mapped folder:

```powershell
.\download-tools.ps1
```

> Run this in PowerShell 7 with appropriate execution policy (`Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` if needed).

### ✅ Step 2: Update the `.wsb` Configuration

Open the `.wsb` file you're using (e.g., `vscode-aspire-install-from-host.wsb`) and update the `HostFolder` path to match the full path on your machine:

The default value for `HostFolder` is.

```xml
<HostFolder>C:\data\mycode\sayedha-sandbox\mapped-folder</HostFolder>
```

The `HostFolder` path **must be absolute** — relative paths are not supported by `.wsb` files.

### ✅ Step 3: Launch the Sandbox

Double-click the `.wsb` file. The command prompt will show installation progress as tools are installed from local files.

---

## 📁 Files Overview

- `download-tools.ps1`: Downloads installers to the mapped folder.
- `install-tools.bat`: Runs in Sandbox to install tools and apply configuration.
- `vscode-aspire.wsb`: Easiest option, uses Winget to install in Sandbox.
- `vscode-aspire-install-from-host.wsb`: Fast reusable option, uses pre-downloaded installers.

---

## 🔁 Reuse

Run `download-tools.ps1` again anytime to refresh the tools on your host.

Each time you start Sandbox with the "from host" config, the setup runs fast and offline using the cached files.
