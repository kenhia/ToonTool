# I generally follow the "don't use aliases" in scripts, but there are a couple I do use especially when
# it fits better on one line and doesn't effect readablity (I think it often improves it)...this is generally
# when I'm piping to where/Where-Object and select/Select-Object
#
# Write-Host is not the evil that some PS-ers make it out to be; use it correctly and don't expect to have the
# output capturable.
@{
    Severity=@('Error','Warning')
    ExcludeRules=@('PSAvoidUsingCmdletAliases',
                'PSAvoidUsingWriteHost')
}