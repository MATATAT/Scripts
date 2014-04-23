# Pulls list of all SP names from database described in connection string
# then scans all files described in $files. The script can be easily edited
# to work with any database and any set of code. Just change the connection string
# and alter the collection of file paths. Note that this script isn't well optimized,
# it will read every file several times for usage of each SP. The more files
# you chose to scan the longer the script will take.

$query = "SELECT pr.name FROM sys.procedures pr";
$connString = "Data Source=.;Initial Catalog=CartellaDev3;User Id=sa;Password=ingeniux";
$cartellaLibsFilePath = "W:\Code\Dev40\Libs\CartellaLibs";
$controllersFilePath = "W:\Code\Dev40\View\Cartella\Cartella\Controllers";
$output = "C:\Users\mmcdonald\Desktop\storedProcedures_NotUsed.txt";

$conn = new-object system.data.sqlclient.sqlconnection($connString);
$cmd = new-object system.data.sqlclient.sqlcommand($query, $conn);
$conn.Open();

$dataSet = new-object system.data.dataset;
$dataAdapter = new-object system.data.sqlclient.sqldataadapter($cmd);
$dataAdapter.fill($dataSet);

$conn.Close();

# need to get files here
$files = get-childitem $cartellaLibsFilePath -Recurse -Include *.cs;
$files += get-childitem $controllersFilePath -Recurse -Include *.cs;

$counter = 0;
$lastPercentage = 0;

function getMatches
{
	foreach	($tableName in $dataSet.Tables[0].Rows)
	{
		$matchFound = $False;
		$regExp = "\S?[""]{1}" + $tableName.Name + "[""]{1}\S?";
		
		foreach	($file in $files)
		{
			$result = get-content $file.FullName | select-string -Pattern $regExp -quiet;
			if ($result -eq $True)
			{
				$matchFound = $True;
			}
		}
		
		if (!$matchFound)
		{
			$tableName.Name | out-file $output -Append
		}
		
		# Print percentage complete, mostly to show that the script is indeed running since it takes a while
		$counter++;
		$percentage = [System.Math]::Round(($counter / $dataSet.Tables[0].Rows.Count) * 100);
		if ($percentage -gt $lastPercentage)
		{
			echo $percentage%;
			$lastPercentage = $percentage;
		}
	}
}

getMatches