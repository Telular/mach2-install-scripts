### Install .net 4.6
$url = "https://download.microsoft.com/download/5/1/1/511BD803-609C-4B08-BD52-D6FC1835018F/NDP46-KB3006563-x86-x64-AllOS-ENU.exe";
$output = "c:\NDP46-KB3006563-x86-x64-AllOS-ENU.exe"

Invoke-WebRequest -Uri $url -OutFile $output
Start-Process -FilePath $output -ArgumentList "/q /norestart" -Wait -Verb RunAs

### Node Install

$url = "https://nodejs.org/dist/v6.11.4/node-v6.11.4-x64.msi";
$output = "c:\node-v6.11.4-x64.msi"

Invoke-WebRequest -Uri $url -OutFile $output
msiexec /qn /l* c:\node-log.txt /i $output

### Python Install (for robot framework stuff)
$url = "https://www.python.org/ftp/python/2.7.14/python-2.7.14.msi";
$output = "c:\python-2.7.14.msi"

Invoke-WebRequest -Uri $url -OutFile $output
msiexec /i $output

###### Python install extras for robot framework
pip install decorator==4.0.10
pip install docutils==0.12
pip install pygments==2.0.2
pip install requests==2.10.0
pip install robotframework==3.0
pip install robotframework-ride==1.5.2.1
pip install robotframework-selenium2library==1.8.0
pip install selenium==3.0.1
pip install simplejson==3.8.2
pip install robotframework-requests==0.4.7
pip install requests

### Open ports on Firewall

