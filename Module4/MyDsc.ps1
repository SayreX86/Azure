#region DSC Configuration Definitions

Configuration $ConfigName
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName xWebAdministration

    Node $AllNodes.NodeName
    {
        LocalConfigurationManager
        {
            ConfigurationModeFrequencyMins = 60
            ConfigurationMode = 'ApplyOnly'
            RefreshMode = 'Push'
            RebootNodeIfNeeded = $true
        }
  
        #region Windows Features

        # Web Server (IIS)
        WindowsFeature Web-Server
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }

        # Web Server (IIS) > Web Server
        WindowsFeature Web-WebServer
        {
            Ensure = 'Present'
            Name = 'Web-WebServer'
            DependsOn = '[WindowsFeature]Web-Server'
        }

        # Web Server (IIS) > Web Server > Common HTTP Features
        WindowsFeature Web-Common-Http
        {
            Ensure = 'Present'
            Name = 'Web-Common-Http'
            DependsOn = '[WindowsFeature]Web-WebServer'
        }

        # Web Server (IIS) > Web Server > Common HTTP Features > Default Document
        WindowsFeature Web-Default-Doc
        {
            Ensure = 'Present'
            Name = 'Web-Default-Doc'
            DependsOn = '[WindowsFeature]Web-Common-Http'
        }

        # Web Server (IIS) > Web Server > Common HTTP Features > Directory Browsing
        WindowsFeature Web-Dir-Browsing
        {
            Ensure = 'Present'
            Name = 'Web-Dir-Browsing'
            DependsOn = '[WindowsFeature]Web-Common-Http'
        }

        # Web Server (IIS) > Web Server > Common HTTP Features > HTTP Errors
        WindowsFeature Web-Http-Errors
        {
            Ensure = 'Present'
            Name = 'Web-Http-Errors'
            DependsOn = '[WindowsFeature]Web-Common-Http'
        }

        # Web Server (IIS) > Web Server > Common HTTP Features > Static Content
        WindowsFeature Web-Static-Content
        {
            Ensure = 'Present'
            Name = 'Web-Static-Content'
            DependsOn = '[WindowsFeature]Web-Common-Http'
        }

        # Web Server (IIS) > Web Server > Common HTTP Features > HTTP Redirection
        WindowsFeature Web-Http-Redirect
        {
            Ensure = 'Present'
            Name = 'Web-Http-Redirect'
            DependsOn = '[WindowsFeature]Web-Common-Http'
        }

        # Web Server (IIS) > Web Server > Health and Diagnostics
        WindowsFeature Web-Health
        {
            Ensure = 'Present'
            Name = 'Web-Health'
            DependsOn = '[WindowsFeature]Web-WebServer'
        }

        # Web Server (IIS) > Web Server > Health and Diagnostics > HTTP Logging
        WindowsFeature Web-Http-Logging
        {
            Ensure = 'Present'
            Name = 'Web-Http-Logging'
            DependsOn = '[WindowsFeature]Web-Health'
        }

        # Web Server (IIS) > Web Server > Health and Diagnostics > Logging Tools
        WindowsFeature Web-Log-Libraries
        {
            Ensure = 'Present'
            Name = 'Web-Log-Libraries'
            DependsOn = '[WindowsFeature]Web-Health'
        }

        # Web Server (IIS) > Web Server > Health and Diagnostics > Request Monitor
        WindowsFeature Web-Request-Monitor
        {
            Ensure = 'Present'
            Name = 'Web-Request-Monitor'
            DependsOn = '[WindowsFeature]Web-Health'
        }

        # Web Server (IIS) > Web Server > Health and Diagnostics > Tracing
        WindowsFeature Web-Http-Tracing
        {
            Ensure = 'Present'
            Name = 'Web-Http-Tracing'
            DependsOn = '[WindowsFeature]Web-Health'
        }

        # Web Server (IIS) > Web Server > Security
        WindowsFeature Web-Security
        {
            Ensure = 'Present'
            Name = 'Web-Security'
            DependsOn = '[WindowsFeature]Web-WebServer'
        }

        # Web Server (IIS) > Web Server > Security > Request Filtering
        WindowsFeature Web-Filtering
        {
            Ensure = 'Present'
            Name = 'Web-Filtering'
            DependsOn = '[WindowsFeature]Web-Security'
        }

        # Web Server (IIS) > Web Server > Security > URL Authorization
        WindowsFeature Web-Url-Auth
        {
            Ensure = 'Present'
            Name = 'Web-Url-Auth'
            DependsOn = '[WindowsFeature]Web-Security'
        }

        # Web Server (IIS) > Web Server > Application Development
        WindowsFeature Web-App-Dev
        {
            Ensure = 'Present'
            Name = 'Web-App-Dev'
            DependsOn = '[WindowsFeature]Web-WebServer'
        }

        # Web Server (IIS) > Web Server > Application Development > .NET Extensibility 4.5
        WindowsFeature Web-Net-Ext45
        {
            Ensure = 'Present'
            Name = 'Web-Net-Ext45'
            DependsOn = '[WindowsFeature]Web-App-Dev'
        }

        # Web Server (IIS) > Web Server > Application Development > Application Initialization
        WindowsFeature Web-AppInit
        {
            Ensure = 'Present'
            Name = 'Web-AppInit'
            DependsOn = '[WindowsFeature]Web-App-Dev'
        }

        # Web Server (IIS) > Web Server > Application Development > ASP.NET 4.5
        WindowsFeature Web-Asp-Net45
        {
            Ensure = 'Present'
            Name = 'Web-Asp-Net45'
            DependsOn = '[WindowsFeature]Web-App-Dev'
        }

        # Web Server (IIS) > Web Server > Application Development > ISAPI Extensions
        WindowsFeature Web-ISAPI-Ext
        {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Ext'
            DependsOn = '[WindowsFeature]Web-App-Dev'
        }

        # Web Server (IIS) > Web Server > Application Development > ISAPI Filters
        WindowsFeature Web-ISAPI-Filter
        {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Filter'
            DependsOn = '[WindowsFeature]Web-App-Dev'
        }

        # Web Server (IIS) > Web Server > Management Tools
        WindowsFeature Web-Mgmt-Tools
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Tools'
            DependsOn = '[WindowsFeature]Web-Server'
        }

        # Web Server (IIS) > Web Server > Management Tools > IIS Management Console
        WindowsFeature Web-Mgmt-Console
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Console'
            DependsOn = '[WindowsFeature]Web-Mgmt-Tools'
        }

        # Web Server (IIS) > Web Server > Management Tools > IIS Management Scripts and Tools
        WindowsFeature Web-Scripting-Tools
        {
            Ensure = 'Present'
            Name = 'Web-Scripting-Tools'
            DependsOn = '[WindowsFeature]Web-Mgmt-Tools'
        }

        # Web Server (IIS) > Web Server > Management Tools > Management Service
        WindowsFeature Web-Mgmt-Service
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Service'
            DependsOn = '[WindowsFeature]Web-Mgmt-Tools'
        }

        # .NET Framework 4.5 Features
        WindowsFeature NET-Framework-45-Features
        {
            Ensure = 'Present'
            Name = 'NET-Framework-45-Features'
        }

        # .NET Framework 4.5 Features > ASP.NET 4.5 (Required by .NET Extensibility 4.5)
        WindowsFeature NET-Framework-45-ASPNET
        {
            Ensure = 'Present'
            Name = 'NET-Framework-45-ASPNET'
            DependsOn = '[WindowsFeature]NET-Framework-45-Features'
        }

        #endregion Windows Features

        #region IIS Configuration

        # Disable Incremental Site ID Computation
        Registry IncrementalSiteIDCreation
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Inetmgr\Parameters'
            ValueName = 'IncrementalSiteIDCreation'
            ValueData = '0'
            ValueType = 'Dword'
            Force = $true
            DependsOn = '[WindowsFeature]Web-Server'
        }
       #endregion IIS Configuration
    }

}

#endregion DSC Configuration Definitions

#region Main

try {
    Start-DscConfiguration -Path $outputDirPath -ComputerName 'localhost' -Force -Wait -Verbose -ErrorAction Stop
}
finally {
}

#endregion Main
