# ------------------ Descripción general del cometido del script -----------------
# El objetivo de este script es generar un fichero informativo que liste todos los
# procesos ordendos por el número de handles abiertos. El listado se organiza
# en tres tramos. En el primer tramo se imprimen los procesos entre 0 y 100 handles,
# en el segundo tramo, entre 101 y 1000 handles, y en el tercer tramo los
# que utilizan más de 1000.
# El nombre del fichero en el que se genera el informe es introducido por
# consola.
# El fichero generado se almacena en el directorio C:\Temp. Si este directorio no
# existe, se aborta la ejecución del script.
# --------------------------------------------------------------------------------

# Comprobación de la existencia del directorio C:\Temp. Si este directorio no
# existe se envía un mensaje a la consola indicado el problema y se aborta la
# ejecución del script

# if (!(Test-Path -Path "C:\Temp")) {
#     Write-Host "El directorio C:\Temp no existe. Abortando la ejecución del script" -ForegroundColor Red
#     exit
# }

# Solicitar el nombre del fichero de salida y cargarlo en la variable $file
$file = Read-Host -Prompt "Introduce el nombre del fichero de salida"

# Generación de una línea en blanco en la consola
Write-Host

# Guardar en el array $Procesos todos los procesos en ejecución
# ordenados por su número de handles
$Procesos = Get-Process | Sort-Object Handles

# Creación del fichero informativo
$file = "./$file.txt"
New-Item -Path $file -ItemType File -Force

######## Procesos entre 0 y 100 ########

# Escribir en el fichero el intervalo de procesos
Add-Content -Path $file -Value "Procesos entre 0 y 100 handles" -Encoding UTF8

# Escribir en el fichero una cabecera apropiada para la tabla de procesos
$Cabecera = "Num. de handles" + " " + "Nombre del proceso"
Add-Content -Path $file -Value $Cabecera -Encoding UTF8

# Escribir en el fichero informativo los procesos cuyo Nº de handles se encuentre
# entre 0 y 100. Para ello, se utilizará un bucle foreach.
# Dentro del cuerpo del bucle se generará en la variable $Linea la información
# correspondiente a cada proceso. Se utilizará formateo extendido de cadenas
# para formatear cada línea apropiadamente.
foreach ($Proceso in $Procesos) {
    if ($Proceso.Handles -lt 101) {
        $Valor = If ($Proceso.Handles -eq $null) { "0" } Else { $Proceso.Handles }
        $Linea = "{0,-15}" -f $Valor + " " + "{0,-20}" -f $Proceso.Name
        Add-Content -Path $file -Value $Linea -Encoding UTF8
    }
}
# Línea en blanco en fichero
Add-Content -Path $file -Value " "


######## Procesos entre 101 y 1000 ########

# Escribir en el fichero el intervalo de procesos
Add-Content -Path $file -Value "Procesos entre 101 y 1000 handles" -Encoding UTF8

# Escribir en el fichero una cabecera apropiada para la tabla de procesos
$Cabecera = "Num. de handles" + " " + "Nombre del proceso"
Add-Content -Path $file -Value $Cabecera -Encoding UTF8

# Escribir en el fichero informativo los procesos cuyo Nº de handles se encuentre
# entre 101 y 1000. Para ello, se utilizará un bucle foreach.
# Dentro del cuerpo del bucle se generará en la variable $Linea la información
# correspondiente a cada proceso. Se utilizará formateo extendido de cadenas
# para formatear cada línea apropiadamente.
foreach ($Proceso in $Procesos) {
    if (($Proceso.Handles -gt 100) -and ($Proceso.Handles -lt 1001)) {
        $Linea = "{0,-15}" -f $Proceso.Handles + " " + "{0,-20}" -f $Proceso.Name
        Add-Content -Path $file -Value $Linea -Encoding UTF8
    }
}
# Línea en blanco en fichero
Add-Content -Path $file -Value " "



######## Procesos con más de 1000 handles ########

# Escribir en el fichero el intervalo de procesos
Add-Content -Path $file -Value "Procesos con mas de 1000 handles" -Encoding UTF8

# Escribir en el fichero una cabecera apropiada para la tabla de procesos
$Cabecera = "Num de handles" + " " + "Nombre del proceso"
Add-Content -Path $file -Value $Cabecera -Encoding UTF8

# Escribir en el fichero informativo los procesos cuyo Nº de handles sea mayor de 1000
foreach ($Proceso in $Procesos) {
    if ($Proceso.Handles -gt 1000) {
        $Linea = "{0,-15}" -f $Proceso.Handles + " " + "{0,-20}" -f $Proceso.Name
        Add-Content -Path $file -Value $Linea -Encoding UTF8
    }
}
# Línea en blanco en fichero
Add-Content -Path $file -Value " "

# Generación de una línea en blanco en la consola
Write-Host

# Mensaje informativo
Write-Host "El fichero $file ha sido generado" -ForegroundColor Green
