$port=8080; $root=$PSScriptRoot
$l=New-Object System.Net.HttpListener; $l.Prefixes.Add("http://localhost:$port/")
try{$l.Start()}catch{Write-Host "Port $port is busy. Close other servers and try again.";pause;exit}
Write-Host "Server running at http://localhost:$port/  - keep this window open until the app is installed."
Start-Process "http://localhost:$port/index.html"
$mime=@{'.html'='text/html; charset=utf-8';'.js'='text/javascript';'.json'='application/json';'.webmanifest'='application/manifest+json';'.png'='image/png';'.css'='text/css'}
while($l.IsListening){$c=$l.GetContext();$p=$c.Request.Url.LocalPath;if($p -eq '/'){$p='/index.html'}
 $f=[IO.Path]::GetFullPath((Join-Path $root ($p.TrimStart('/') -replace '/','\')))
 if($f.StartsWith($root) -and (Test-Path $f -PathType Leaf)){$b=[IO.File]::ReadAllBytes($f);$e=[IO.Path]::GetExtension($f).ToLower()
  $c.Response.ContentType=$(if($mime[$e]){$mime[$e]}else{'application/octet-stream'});$c.Response.OutputStream.Write($b,0,$b.Length)}else{$c.Response.StatusCode=404}
 $c.Response.Close()}
