Function New-SCPTServer {
    Param (
        [Parameter(Mandatory=$false)]
        [ValidateSet("2016-English-Full","2016-English-Core")]
        [string]$OSSKU = '2016-English-Full',
        $SourceImageFilters = @(
            @{Name='name';Value="Windows_Server-$($OSSKU)-Base-*"},
            @{Name='is-public';Value='true'},
            @{Name='owner-alias';Value='amazon'}
        ),
        $SourceImage = (Get-EC2Image -Filter $SourceImageFilters | Sort-Object -Property CreationDate -Descending | Select-Object -First 1),
        $SourceImageId = ($SourceImage.ImageId),
        [string]$IamInstanceProfileName = $(Get-SSMParameterValue -Name SCPT_IamInstanceProfileName | %{$_.parameters.value}),
        [string]$OutputS3BucketName = $(Get-SSMParameterValue -Name SCPT_OutputS3BucketName | %{$_.parameters.value}),
        [string]$InstanceType = 't2.small',
        [string]$SubnetId = $(Get-SSMParameterValue -Name SCPT_SubnetID | %{$_.parameters.value}),
        [string]$SecurityGroupId = $(Get-SSMParameterValue -Name SCPT_SecurityGroupIds | %{$_.parameters.value}),
        [string]$KeyName = $(Get-SSMParameterValue -Name SCPT_Keypair | %{$_.parameters.value})
    )
    $parameters = @{
        ImageId = $SourceImageId;
        AssociatePublicIp = 1;
        MinCount = 1;
        MaxCount = 1;
        KeyName = $KeyName;
        SecurityGroupIds = $SecurityGroupId;
        InstanceType = $InstanceType;
        Monitoring_Enabled = 1;
        SubnetId = $SubnetId;
        InstanceProfile_Name = $IamInstanceProfileName;
    }
    Write-Host "$($parameters | out-string)"
    $instanceReturn = New-EC2Instance @parameters
    return $instanceReturn.Instances[0]
}