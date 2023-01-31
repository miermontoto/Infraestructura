
$a = get-wmiobject -class win32_ComputerSystem -namespace root\cimv2 -computername .

$temp = "C:\Temp"
if(!(test-path $temp)){ 
    write-host "El directorio C:\Temp no existe"
    exit
}

$ruta = $temp + "\PC_Info.txt"

if(test-path $ruta) { 
	write-host "El fichero PC_Info.txt ya existe" 
	exit
}

else{
	new-item -path $ruta -type file
}

add-content -path $ruta -value ("---------------------------------- EQUIPO ----------------------------------")
add-content -path $ruta -value ("Nombre del equipo: " + $a.name)
add-content -path $ruta -value ("Dominio del equipo: " + $a.domain)
add-content -path $ruta -value("")

add-content -path $ruta -value("---------------------------------- HARDWARE ----------------------------------")
$procesador = get-wmiobject -class win32_processor
add-content -path $ruta -value("Procesador: " + $procesador.name)

$moduloMemoria = Get-WmiObject -Class win32_physicalmemory

if(!$moduloMemoria.gettype().isarray){ 
 Add-Content -Path $ruta -Value ("Tamaño de los modulos: " + 1)
 }
 
 else{
   Add-Content -Path $ruta -Value ("Numero de módulos de memoria: " + $moduloMemoria.count)
 }
 
 $capacidad_ram = 1 
 
 foreach($mod in $moduloMemoria){
    Add-Content -Path $ruta -Value ("Tamaño del módulo " + $capacidad_ram+" GB: "+ $mod.Capacity/(1024*1024*1024))
    $capacidad_ram++
 }
 
$discos = get-wmiobject -class win32_diskdrive

if(!$discos.gettype().isarray){
    add-content -path $ruta -value("Número de discos instalados: " + 1)
} else { add-content -path $ruta -value("Número de discos instalados: " + $discos.count) }

$capacidad_disco = 1

foreach($disc in $discos){
    add-content -path $ruta -value("Tamaño del disco " + $capacidad_disco + " GB: " + $disc.size/(1024*1024*1024))
    $capacidad_disco++
}

add-content -path $ruta -value("---------------------------------- DATOS DEL SO ----------------------------------")
$so = get-wmiobject -class win32_operatingsystem
add-content -path $ruta -value("Edición de Windows: " + $so.caption)
Add-Content -Path $ruta -Value("Código del pais: "+$so.countrycode)
$tipoproducto = $so.producttype
switch($tipoproducto){
    1 { add-content -path $ruta -value("Tipo de producto: Workstation") }
    2 { add-content -path $ruta -value("Tipo de producto: Domain Controller") }
    default { add-content -path $ruta -value("Tipo de producto: Server") } 
}


add-content -path $ruta -value("---------------------------------- LISTADO DE VOLÚMENES ----------------------------------")
$discos = get-wmiobject -class win32_volume
$n_disco = 0
foreach($disco in $discos){
    add-content -path $ruta -value("===== Volumen " + $n_disco + " =====")
    add-content -path $ruta -value("Letra asignada: " + $disco.driveletter)
    add-content -path $ruta -value("Capacidad en MB: " + $disco.capacity/(1024*1024))
	switch($disco.drivetype){
		0 { add-content -path $ruta -value("Tipo de drive: Desconocido")}
		1 { add-content -path $ruta -value("Tipo de drive: No directorio raíz")}
		2 { add-content -path $ruta -value("Tipo de drive: Disco extraible")}
		3 { add-content -path $ruta -value("Tipo de drive: Disco local")}
		4 { add-content -path $ruta -value("Tipo de drive: Disco en red")}
		5 { add-content -path $ruta -value("Tipo de drive: CD")}
		6 { add-content -path $ruta -value("Tipo de drive: Disco RAM")}
	}
    
	add-content -path $ruta -value("Sistema de ficheros: " + $disco.filesystem)
    $n_disco++
}
