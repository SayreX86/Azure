configuration MyDSC2
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
	
	Node WEB
    {
		WindowsFeature IIS
        {
            Ensure  = 'Present'
            Name    = 'Web-Server'
        }

        WindowsFeature Web-Mgmt-Tools
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Tools'
            DependsOn = '[WindowsFeature]Web-Server'
        }

        WindowsFeature Web-Mgmt-Console
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Console'
            DependsOn = '[WindowsFeature]Web-Mgmt-Tools'
        }
    }
	
	Node NOTWEB
    {
        WindowsFeature IIS
        {
            Ensure  = 'Absent'
            Name    = 'Web-Server'
        }
    }
}

MyDSC2