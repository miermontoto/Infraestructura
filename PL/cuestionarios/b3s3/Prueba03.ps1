Write-Host "Script que genera un fichero informativo de un proceso indicado mediante su ID `r`n"
$id = Read-Host "Introduzca el ID del proceso"
$proceso = Get-Process -Id $id
$path = Read-Host "Introduce la ruta de la carpeta en la que se creará el fichero informativo del proceso"
$filename = $path + "\$($proceso.Name).txt"
rm $filename
$proceso | Format-List -Property Name,Id,StartTime | Out-File $filename
Get-Content $filename
