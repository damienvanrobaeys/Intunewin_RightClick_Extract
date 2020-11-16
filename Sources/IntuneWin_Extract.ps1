#========================================================================
#
# Author 	: systanddeploy (Damien VAN ROBAEYS)
# Website	: http://www.systanddeploy.com/
#
#========================================================================


Param
 (
	[String]$ScriptPath	
 )
 


$FolderPath = Split-Path (Split-Path "$ScriptPath" -Parent) -Leaf
$DirectoryName = (get-item $ScriptPath).DirectoryName
$FileName = (get-item $ScriptPath).BaseName

$ProgData = $env:PROGRAMDATA
$RightClick_Path = "$ProgData\IntuneWin_Extract"

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

set-location $RightClick_Path
& .\IntuneWinAppUtilDecoder.exe $ScriptPath -s	

$IntuneWinDecoded_File_Name = "$DirectoryName\$FileName.Intunewin.decoded"	

new-item "$DirectoryName\$FileName" -Type Directory -Force | out-null

$IntuneWin_Rename = "$FileName.zip"

Rename-Item $IntuneWinDecoded_File_Name $IntuneWin_Rename -force

$Extract_Path = "$DirectoryName\$FileName"
Expand-Archive -LiteralPath "$DirectoryName\$IntuneWin_Rename" -DestinationPath $Extract_Path -Force

Remove-Item "$DirectoryName\$IntuneWin_Rename" -force
sleep 1
[System.Windows.Forms.MessageBox]::Show("Your intunewin package has been correctly exported")
# invoke-item $Extract_Path



