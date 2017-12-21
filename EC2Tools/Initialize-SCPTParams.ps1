Function Initialize-SCPTParams {
    Param (
        [string[]]$ParamList = @(
            'SCPT_IamInstanceProfileName',
            'SCPT_SubnetID',
            'SCPT_SecurityGroupId',
            'SCPT_OutputS3BucketName',
            'SCPT_Keypair'
        )
    )
    Foreach ($itemName in $ParamList) {
        $item = Get-SSMParameterValue -Name $itemName -ErrorAction:SilentlyContinue
        if ($item) {
            Write-Host "SCPT Parameter Found. $itemName`:`t$($item.parameters.value)"
        } else {
            Write-Host "SCPT Parameter Missing: $itemName"
            $Params = @{
                Name = $itemName;
                Type = 'String';
                Value = (Read-Host "Please provide a value");
            }
            Write-SSMParameter @Params
        }
    }
}