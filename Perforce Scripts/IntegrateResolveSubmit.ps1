# Connection info
Param ([Parameter(Mandatory=$True)][ValidateNotNull()] $wspace, [Parameter(Mandatory=$True)][ValidateNotNull()] $branch)
$port = "perforce:1666"
$user = "build"

$p4 = '& p4 -c {0} -p {1} -u {2}' -f $wspace, $port, $user

function execCmd($cmd) {
	Invoke-Expression ("$p4 {0}" -f $cmd)
}

# Precautionary revert
execCmd("revert")

#####################
## Integrate files ##
#####################
echo "Integrating..."
execCmd("integrate -o -b $branch")

#############
## Resolve ##
#############
echo "Resolving..."
execCmd("resolve -o -am")

############################
## Revert unchanged files ##
############################
echo "Reverting files..."
execCmd("revert")

#######################
## Create changelist ##
#######################
echo "Creating changelist..."

# Output change form to form.txt
execCmd("change -o > form.txt")

# Manually change description and pipe into change input, pipe output to change
(Get-Content .\form.txt) -replace "<[\w\s]+>", "Cartella: Submitting build changes" | Out-File .\form.txt

############
## Submit ##
############
echo "Submitting changes..."
Get-Content .\form.txt | execCmd("submit -i")

# Cleanup
Remove-Item .\form.txt