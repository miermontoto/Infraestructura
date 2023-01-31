#GESTIONA_PROCESO.PS1 

#Lee el ID
$id = read-host "Id del proceso: "

#Genera linea en blanco
write-host " "

#Seleccionamos el proceso y lo guardamos en la variable $proceso
$proceso = get-wmiobject -query ("Select * from win32_process where  ProcessID = '"+ $id + "' ") -namespace root/cimv2 -computername . 

#Si no existe no hacemos nada
if($proceso -eq $null){ Write-Host "No existe el proceso, se aborta la ejecuccion"} 

#Si si, mostramos opciones al usuario sobre el tratamiento de los datos del proceso
else{
$opcion = read-host "
    1) Obtener ruta del proceso  
    2) Obtener nombre del proceso 
    3) Obtener número de hilos 
    4) Obtener el usuario propietario del proceso
    5) Obtener dominio de ejecución del proceso
    6) Terminar la ejecución del proceso "
write-host ""
switch($opcion){
1 { Write-Host($proceso.ExecutablePath) }
2 { Write-Host($proceso.ProcessName) }
3 { Write-Host($proceso.ThreadCount) }
4 { Write-Host($proceso.GetOwner().User) }
5 { Write-Host($proceso.GetOwner().Domain) }
6 { 
  $terminar=$proceso.Terminate()
  switch($terminar){
	#Se explica por qué terminó
     0 {Write-Host("Terminado con éxito")}
     2 {Write-Host("Acceso denegado")}
     3 {Write-Host("Privilegios insuficientes")}
     8 {Write-Host("Fallo desconocido")}
     9 {Write-Host("Ruta no encontrada")}
     21 {Write-Host("Parámetro incorrecto")}
     

  }
}
#Si se da un valor no válido
default {Write-Host("Opción inválida")}
}

}
