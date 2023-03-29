# Crear un script que defina un array con los números del 0 al 9
# y muestre por pantalla los elementos del array que sean pares.
# Se ha de utilizar una estructura iterativa.

$Array = 0..9
ForEach ($i in $Array)
{
    if ($i % 2 -eq 0)
    {
        Write-Host $i
    }
}
