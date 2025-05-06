# Windows Sandbox Dev Environment Setup

This setup uses `download-tools.ps1` on the host to prepare installer files, and `install-tools.bat` inside Windows Sandbox to install and configure tools like Git, VS Code, .NET SDK, PowerShell 7, and ConEmu.

---

## ✅ Step 1: Download Tools on the Host

Run the following PowerShell script **on your host machine** to download all necessary installers into the mapped folder:

```powershell
.\download-tools.ps1
```

> Make sure PowerShell 7 is installed and execution policy allows scripts. You can run this in an elevated PowerShell prompt if needed.

---

## ✅ Step 2: Create a `.wsb` Configuration File

Create a `sandbox.wsb` file like the following and save it anywhere on your machine:

```xml
<Configuration>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>C:\data\mycode\sayedha-sandbox\mapped-folder</HostFolder>
      <SandboxFolder>C:\setup</SandboxFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>cmd.exe /k C:\setup\install-tools.bat</Command>
  </LogonCommand>
</Configuration>
```

> This maps the folder with your installers and runs the install script automatically when Sandbox starts.

---

## ✅ Step 3: Launch the Sandbox

Double-click the `.wsb` file. Windows Sandbox will start and run `install-tools.bat` to install and configure the tools.

You’ll see the console window stay open so you can monitor progress.

---

## 📁 Files Overview

- `download-tools.ps1`: Downloads all required installers to the mapped folder.
- `install-tools.bat`: Runs in Sandbox to install tools and configure the environment.
- `mapped-folder\PatchSandbox.ps1`: Patches the sandbox to workaround slow install times.
---

## 🔁 Reuse

Rerun `download-tools.ps1` anytime to update tools. The Sandbox remains disposable, so you always start clean.

---
