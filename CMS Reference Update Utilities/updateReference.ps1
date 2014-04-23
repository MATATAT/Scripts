# Powershell regexp syntax: http://ss64.com/ps/syntax-regex.html
# Since Powershell regexp scans a string for instances of the string
# using a string like 'x9' will update both 'x9' and 'x954' alike.
# You can change a specific values with a string like this 'x2$'

function touchFile($file)
{
	$file.Changed = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHH:mm:ss");
	Write-Host $file.ID has updated time: $file.Changed UTC time;
}

$cmsLoc = [System.IO.Path]::GetFullPath((Join-Path (pwd) $args[0])) + "\reference.xml";
$elementPattern = $args[1];

[xml]$reference = Get-Content $cmsLoc;
$siteRoot = $reference.Site;
$children = $siteRoot.ChildNodes;
$queue = New-Object System.Collections.Queue;

foreach ($child in $children) 
{
	$queue.Enqueue($child);
}

while ($queue.Count -gt 0)
{
	$page = $queue.Dequeue();
	
	if ($page.ID -match $elementPattern)
	{
		touchFile($page);
	}
	
	foreach ($child in $page.ChildNodes)
	{
		$queue.Enqueue($child);
	}
}

$reference.Save($cmsLoc);