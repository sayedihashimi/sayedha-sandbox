'Applying patch to avoid long install times.' | Write-Host
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy" -Name "VerifiedAndReputablePolicyState" -Value "0"
CiTool.exe -r