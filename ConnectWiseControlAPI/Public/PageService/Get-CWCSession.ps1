function Get-CWCSession {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateSet('Support','Access','Meeting')]
        $Type,
        [string]$Group = $script:defaultGroup,
        [string]$Search,
        [int]$Limit
    )

    $Endpoint = 'Services/PageService.ashx/GetLiveData'

    switch($Type){
        'Support' { $Number = 0 }
        'Meeting' { $Number = 1 }
        'Access' { $Number = 2 }
        default { return Write-Error "Unknown Type, $Type" }
    }

  # Get-CWCSession -Type 'Access' -Group 'ROS' -Search 'ROSLUX' -Limit 10
$Body = ' [ { "HostSessionInfo": { "sessionType": 2, "sessionGroupPathParts": [ "ROS" ], "filter": "ROSLUX", "findSessionID": null, "sessionLimit": 10, }, "ActionCenterInfo": {} }, 0 ] '

#    $Body = ConvertTo-Json @(
#       @{
#           'HostSessionInfo' = @{
#               'sessionType'           = $Number;
#               'sessionGroupPathParts' = @( $Group, $Null );
#               'filter'                = $Search;
#               'findSessionID'         = $Null;
#               'sessionLimit'          = $Limit;
#           };
#           'ActionCenterInfo' = @{}
#       }, 0
#   )

    Write-Host "Debug: $( $Body | ConvertTo-Json )"

    Write-Verbose $Body

    $WebRequestArguments = @{
        Endpoint = $Endpoint
        Body = $Body
        Method = 'Post'
    }
    Write-Host "Debug: $( $WebRequestArguments | ConvertTo-Json )"


    $Data =  Invoke-CWCWebRequest -Arguments $WebRequestArguments
    Write-Host "Debug6: $( $Data.ResponseInfoMap.ActionCenterInfo.Sessions )"
    $Data.sessions
}
