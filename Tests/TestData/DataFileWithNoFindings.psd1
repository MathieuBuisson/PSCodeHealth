@{
    AllNodes = 
    @(
        @{
            NodeName                   = "*"
            PsDscAllowPlainTextPassword= $True
            Role                       = "WebServer"
            SourcePath                 = "\\DevBox\SiteContents\Index.html"
            DestinationPath            = "C:\inetpub\wwwroot\Index.html"
            Checksum                   = 'SHA256'
            Force                      = $True
            WebAppPool                 = "DefaultAppPool"
        }
        @{
            NodeName = "WebServer1"
        }
        @{
            NodeName = "WebServer2"
        }
    )
}