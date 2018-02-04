configuration MyDSC2
{	
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xWebAdministration
	
	Node VMWEB
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
        }

        WindowsFeature Web-Mgmt-Console
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Console'
        }
    }
	
	Node VMNOTWEB
    {
        WindowsFeature IIS
        {
            Ensure  = 'Absent'
            Name    = 'Web-Server'
        }
    }
}