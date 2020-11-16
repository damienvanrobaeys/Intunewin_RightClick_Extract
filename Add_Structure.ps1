#***************************************************************************************************************
# Author: Damien VAN ROBAEYS
# Website: http://www.systanddeploy.com
# Twitter: https://twitter.com/syst_and_deploy
#***************************************************************************************************************
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$Current_Folder = split-path $MyInvocation.MyCommand.Path
$Sources = $Current_Folder + "\" + "Sources\*"
If(test-path $Sources)
	{	
		$ProgData = $env:ProgramData
		$Destination_folder = "$ProgData\IntuneWin_Extract"
		If(!(test-path $Destination_folder)){new-item $Destination_folder -type directory -force | out-null}
		copy-item $Sources $Destination_folder -force -recurse
		Get-Childitem -Recurse $Destination_folder | Unblock-file				
		$Intune_Icon = "$Destination_folder\logo.ico"				

		$List_Drive = get-psdrive | where {$_.Name -eq "HKCR_SD"}
		If($List_Drive -ne $null){Remove-PSDrive $List_Drive}
		New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR_SD | out-null
		
		$Intunewin_Shell_Registry_Key = "HKCR_SD:\.intunewin"
		$Intunewin_Key_Label = "Extract intunewin content"
		$Intunewin_Key_Label_Path = "$Intunewin_Shell_Registry_Key\Shell\$Intunewin_Key_Label"
		$Intunewin_Command_Path = "$Intunewin_Key_Label_Path\Command"
		$Command_for_extraction = 'C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -executionpolicy bypass -sta -windowstyle hidden -file C:\\ProgramData\\IntuneWin_Extract\\IntuneWin_Extract.ps1 -NoExit -Command Set-Location -LiteralPath "%V" -ScriptPath "%V"' 
		
		If(!(test-path $Intunewin_Shell_Registry_Key))
		{
			new-item $Intunewin_Shell_Registry_Key | out-null
			new-item "$Intunewin_Shell_Registry_Key\Shell" | out-null
			new-item $Intunewin_Key_Label_Path | out-null
			new-item $Intunewin_Command_Path | out-null	
			Set-Item -Path $Intunewin_Command_Path -Value $Command_for_extraction -force | out-null	
			New-ItemProperty -Path $Intunewin_Key_Label_Path -Name "icon" -PropertyType String -Value $Intune_Icon | out-null			
		}

		If($List_Drive -ne $null){Remove-PSDrive $List_Drive}	
		[System.Windows.Forms.MessageBox]::Show("Intunewin context menu has been added")			
	}
Else
	{
		[System.Windows.Forms.MessageBox]::Show("It seems you don't have dowloaded all the folder structure.`nThe folder Sources is missing !!!")	
	}
