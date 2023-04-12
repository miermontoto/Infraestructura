# Utilizando un bucle ForEach, escribe un script que liste los ficheros
# ubicados en la carpeta actual con la extensión introducida por consola
# por el usuario.

$ext = Read-Host "Introduce la extensión (debes incluir el punto)"
$files = ls -Path . -Filter "*$ext"
Write-Host
ForEach ($file in $files)
{
    Write-Host $file.Name
}
