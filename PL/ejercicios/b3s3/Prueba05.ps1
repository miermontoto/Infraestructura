# Script que imprima en la consola una tabla con todos los procesos
# en ejecución en el sistema. La tabla tendrá tres columnas. En la
# columna de la izquierda se imprimirá el nomnre de cada proceso,
# alineado a la izquierda y con un ancho de 25. En la columna del
# centro se imprimirá la hora de arranque de cada proceso, alineada
# a la izquierda y también con un ancho de 25. Finalmente, en la
# columna de la derecha se imprimirá la prioridad de cada proceso,
# alineada a la derecha y con un ancho de 10.

$procesos = Get-Process
$a = $procesos.Name
$b = $procesos.StartTime
$c = $procesos.BasePriority

Write-Host ("{0,-25} {1,-25} {2,10}" -f "Nombre", "Hora de arranque", "Prioridad")
Write-Host ("{0,-25} {1,-25} {2,10}" -f "------", "---------------", "---------")
ForEach ($i in 0..($procesos.Count - 1))
{
    Write-Host ("{0,-25} {1,-25} {2,10}" -f $a[$i], $b[$i], $c[$i])
}
