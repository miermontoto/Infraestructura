Write-Host "Este script renombra directorios ubicados en C:\Temp`n"
$dir = Read-Host "Introduce el nombre del directorio a renombrar"
$dir_fullPath = "C:\\Temp\\" + $dir
# NOTA: El caracter \, por ser especial, debe precederse de otro carácter \

# Obtener directorio
$O_Directory = Get-CimInstance -Query "Select * from Win32_Directory where name = '$dir_fullPath'" -NameSpace root/cimv2
if ( $O_Directory -ne $null )
{
    $newDirName = Read-Host ("Introduce el nuevo nombre para el directorio " + $dir)
    $newDirName_fullPath = "C:\\Temp\\" + $newDirName
    $ret = Invoke-CimMethod -InputObject $O_Directory -MethodName "Rename" -Arguments @{ Filename = $newDirName_fullPath }

    if ( $ret.ReturnValue -eq 0 )
    {
        Write-Host ("El cambio de nombre se ha realizado con éxito")
    }
    else
    {
        Write-Host ("El cambio de nombre no ha podido realizarse")
    }
}
else
{
    Write-Host("El directorio indicado no existe")
}