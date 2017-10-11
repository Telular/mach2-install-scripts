Write-Host "Installing .net 4.6"
### Install .net 4.6
$url = "https://download.microsoft.com/download/5/1/1/511BD803-609C-4B08-BD52-D6FC1835018F/NDP46-KB3006563-x86-x64-AllOS-ENU.exe";
$output = "c:\NDP46-KB3006563-x86-x64-AllOS-ENU.exe"

Invoke-WebRequest -Uri $url -OutFile $output
Start-Process -FilePath $output -ArgumentList "/q /norestart" -Wait -Verb RunAs

### Node Install
Write-Host "Installing Node"

$url = "https://nodejs.org/dist/v6.11.4/node-v6.11.4-x64.msi";
$output = "c:\node-v6.11.4-x64.msi"

Invoke-WebRequest -Uri $url -OutFile $output
Start-Process -FilePath $output -Wait -ArgumentList '/qn'


### Python Install (for robot framework stuff)
Write-Host "Installing Python"
$url = "https://www.python.org/ftp/python/2.7.14/python-2.7.14.msi";
$output = "c:\python-2.7.14.msi"

Invoke-WebRequest -Uri $url -OutFile $output
Start-Process -FilePath $output -Wait -ArgumentList 'ADDLOCAL="all" /qn'

Write-Host "Updating Path"

[Environment]::SetEnvironmentVariable("Path",$env:Path + "C:\Python27;C:\Python27\Scripts;C:\Python27\Lib","Process")

    #after updating the path we need to let everyone know about it
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath -Force

$HWND_BROADCAST = [IntPtr] 0xffff;
$WM_SETTINGCHANGE = 0x1a;
$result = [UIntPtr]::Zero

if (-not ("Win32.NativeMethods" -as [Type]))
{
    # import sendmessagetimeout from win32
    Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessageTimeout(
    IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
    uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
}
# notify all windows of environment block change
[Win32.Nativemethods]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [UIntPtr]::Zero, "Environment", 2, 5000, [ref] $result);

###### Python install extras for robot framework
Write-Host "Installing Python Pip stuff"
c:\python27\scripts\pip install decorator==4.0.10
c:\python27\scripts\pip install docutils==0.12
c:\python27\scripts\pip install pygments==2.0.2
c:\python27\scripts\pip install requests==2.10.0
c:\python27\scripts\pip install robotframework==3.0
c:\python27\scripts\pip install robotframework-ride==1.5.2.1
c:\python27\scripts\pip install robotframework-selenium2library==1.8.0
c:\python27\scripts\pip install selenium==3.0.1
c:\python27\scripts\pip install simplejson==3.8.2
c:\python27\scripts\pip install robotframework-requests==0.4.7
c:\python27\scripts\pip install requests
c:\python27\scripts\pip install -U wxPython

### Open ports on Firewall
netsh advfirewall firewall add rule name="LWM2M-UDP" dir=in action=allow protocol=UDP localport=5683
netsh advfirewall firewall add rule name="LWM2M-UDP-DTLS" dir=in action=allow protocol=UDP localport=5684
netsh advfirewall firewall add rule name="LWM2M-TCP" dir=in action=allow protocol=TCP localport=5443
