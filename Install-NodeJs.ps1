### Node Install

$url = "https://nodejs.org/dist/v6.11.4/node-v6.11.4-x64.msi";
$output = "c:\node-v6.11.4-x64.msi"

Invoke-WebRequest -Uri $url -OutFile $output
msiexec /qn /l* c:\node-log.txt /i $output

### Python Install (for robot framework stuff)
$url = "https://www.python.org/ftp/python/2.7.14/python-2.7.14.msi";
$output = "python-2.7.14.msi"

Invoke-WebRequest -Uri $url -OutFile $output
msiexec /i $output



