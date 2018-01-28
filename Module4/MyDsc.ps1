#region DSC Configuration Definitions

Configuration IISWebSite
{
    param 
    (
        [System.String[]]
        $NodeName = "localhost"
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xWebAdministration

    Node $NodeName
    {
        #region Windows Features

        # Web Server (IIS)
        WindowsFeature Web-Server
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }
        
        #endregion Windows Features
        
        #region Website Configuration

        xWebsite DefaultSite
        {
            Ensure          = 'Present'
            Name            = 'Default Web Site'
            PhysicalPath    = 'C:\inetpub\wwwroot'
            DependsOn       = '[WindowsFeature]Web-Server'
            BindingInfo = @(
            MSFT_xWebBindingInformation
            {
                Protocol              = 'HTTP' 
                Port                  = '8080'
                IPAddress             = '*'
            })
        }
        
        #endregion Website Configuration
    }
}

#endregion DSC Configuration Definitions
