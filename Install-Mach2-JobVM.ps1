############# Functions #####################
function Add-Firewall-Rule{
    Param(
        [string] $DisplayName,
        [string] $Protocol,
        [string] $Port,
        [string] $RuleAction = "allow",
        [string] $RuleDir = "in"
    )

    $_fwRule = Get-NetFirewallRule -DisplayName $DisplayName

    if ($_fwRule -eq $null){
        Write-Host "Rule $DisplayName does not exist... creating"
        netsh advfirewall firewall add rule name=$DisplayName dir=$RuleDir action=$RuleAction protocol=$Protocol localport=$Port
    } else {
        Write-Host "Rule $DisplayName exists"
    }
}

function Add-Directory-To-Path{
    Param(
        [string] $Directory
    )

    $currentPath=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
    if ($currentPath.ToLower().Split(";") -notcontains $Directory.ToLower()){
        Write-Host "Adding $Directory To path"

        if (![string]::IsNullOrEmpty($currentPath)){
            $Directory = ";$Directory"
        }

        $newPath = $currentPath + $Directory

        Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPath
        $env:Path = $newPath

    } else {
        Write-Host "$Directory Already exists in path... moving on"
    }
}

function Reset-Path{

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
}

############# END FUNCTIONS ###################

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
$dirsToAdd = "C:\Python27", "C:\Python27\Scripts", "C:\Python27\Lib"

For($i = 0; $i -lt $dirsToAdd.Length; $i++){
    Add-Directory-To-Path -Directory $dirsToAdd[$i]
}

Reset-Path

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
Add-Firewall-Rule -DisplayName "LWM2M-UDP" -Protocol "UDP" -Port "5683"
Add-Firewall-Rule -DisplayName "LWM2M-UDP-DTLS" -Protocol "UDP" -Port "5684"
Add-Firewall-Rule -DisplayName "LWM2M-TCP" -Protocol "TCP" -Port "5443"
Add-Firewall-Rule -DisplayName "HealthCheck-TCP" -Protocol "TCP" -Port "8080"

