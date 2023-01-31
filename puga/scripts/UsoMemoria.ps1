#USO_MEMORIA.PS1 

#Write-Host "Comprueba si existe el directorio C:\Temp"
$dir="C:\temp"
if(!(Test-Path $dir)){
    Write-Host "El directorio C:\Temp no existe"
    exit
}
# Solicitar el nombre del fichero de salida y cargarlo en la variable $fichero
else{
    $fichero=Read-Host "Introduzca el nombre del fichero: "
	
	# Crea el fichero
	$ruta=$dir+$fichero+".txt"
	
	#Comprueba si existe
	if(test-path $ruta) {
	write-host "El fichero $fichero ya existe" 
	exit
	}
	
    # Genera linea en blanco
    Write-Host ""
	
    # Solicitar el umbral de memoria que determina los procesos a listar
    # y cargarlo en la variable $mem
    $umbral=Read-Host "Introduzce el umbral de memoria: "

    # Guardar en el array $Procesos todos los procesos en ejecución 
	# ordenados por el tamaño de su memoria comprometida
    $vprocesos= Get-Process | Sort-Object –Property PrivateMemorySize 

    # Escribir en el fichero una cabecera apropiada para la tabla de procesos
    New-item -path $ruta -Type file
    
    # Escribir en el fichero una cabecera apropiada para la tabla de procesos
    Add-Content -path $ruta ("{0,-25} {1,0} {2,45}" -f "ID","Nombre","Memoria Compartida")
	add-content -path $ruta -value ("----------------------------------------------------------------------------------------------------------------")
    
    # Escribir en el fichero informativo los procesos cuyo espacio de memoria se encuentre
	# por encima del umbral. Para ello, seutilizaráun bucle do-while.
	# Dentro del cuerpo del bucle se generará en la variable $Linea la información
	# correspondiente a cada proceso. Se utilizará formateo extendido de cadenas
	# para formatear cada línea apropiadamente.

    $pos=0;
    do{
        if($vprocesos[$pos].privatememorysize/1024 -gt $umbral){ 
            $idProceso=$vprocesos[$pos].Id;
            $nombreProceso=$vprocesos[$pos].Name;
            $memorySize=$vprocesos[$pos].PrivateMemorySize/1024; 

            Add-Content -Path $ruta('{0,-25} {1,0} {2,35}' -f $idProceso,$nombreProceso, $memorySize) 
        }
        $pos++;
    }
    while($pos -lt $vprocesos.length)
}