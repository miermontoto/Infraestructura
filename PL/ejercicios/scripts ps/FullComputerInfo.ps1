# Se trata de programar un script que proporcione información variada
# relativa al computador local en el que se ejecuta. La información proporcionada por el script se
# almacena en un fichero de texto llamado CompunterName_Info.txt, donde ComputerName es el
# nombre del computador en el que se ejecuta. El fichero se almacena siempre en el directorio
# C:\Temp. Antes de generar el informe, el script debe realizar dos comprobaciones: 1) que C:\Temp
# existe y 2) que en este directorio no existe un fichero con el mismo nombre que el que va a ser
# generado por el script. Si estas condiciones se cumplen, el fichero informativo se crea y el script
# envía un mensaje a la consola indicando que se ha creado con éxito el fichero informativo
# CompunterName_Info.txt. Si las condiciones anteriores no se cumplen, el script genera un mensaje
# informativo del problema ocurrido y aborta su ejecución.
#
# NOTAS:
#  En la estructura del informe se observa que los valores a mostrar se escriben todos en una
# posición alineada. Para conseguir esto, se compondrá cada línea a escribir utilizando formateo
# extendido de cadenas, según se ha estudiado en la sesión de prácticas anterior.
#  Algunas clases WMI, al ser instanciadas, pueden devolver o bien un objeto simple, o bien un
# array de objetos, siendo necesario hacer un tratamiento diferenciado en cada uno de estos casos.
# Para conocer si el resultado del instanciado de una clase WMI es un objeto simple o un array de
# Universidad de Oviedo / Dpto. de Informática
# 11objetos, debe utilizarse la propiedad IsArray del método GetType(), aplicable a cualquier
# variable. A continuación, se proporciona una ejemplo:
# $a = 1, 2, 3
# $a.GetType().Isarray
# True
# $a = 1
# $a.GetType().Isarray
# False
#  Para conocer los discos instalados en el sistema debe utilizarse la clase Win32_DiskDrive. Esta
# clase debe tratarse de la forma apropiada utilizando GetType().Isarray.
#  Para conocer los volúmenes instalados en el sistema debe utilizarse la clase Win32_Volume. Esta
# clase debe tratarse de la forma apropiada utilizando GetType().Isarray.
#
# A continuación se proporciona la estructura del informe a generar por el script:
#
# ----------------------------- Identificación del equipo ---------------------------------
# Nombre equipo:         XXX
# Dominio:               XXX
# ----------------------------- Información del sistema operativo -------------------------
# Edición de Windows:    XXX
# Fecha de instalación:  XXX
# Directorio de Windows: XXX
# Arquitectura del SO:   XXX
# Tipo de producto:      XXX [Expresado en cadena de caracteres, según ayuda]
# ----------------------------- Listado de discos ------------------------------------------
# Nº de discos:          XXX
# ============ Disco 0 =========
# Nombre:                XXX
# Modelo:                XXX
# Tamaño (en GB):        XXX
# ...
# ============ Disco N =========
# Nombre:                XXX
# Modelo:                XXX
# Tamaño (en GB):        XXX
# ----------------------------- Listado de volúmenes --------------------------------------
# Nº de volúmenes:       XXX
# ============ Volumen 0 =======
# Letra asignada:        XXX
# Capacidad (en MB):     XXX
# Espacio libre (en MB): XXX
# Tipo de drive:         XXX [Expresado en cadena de caracteres, según ayuda]
# Sistema de ficheros:   XXX
# ...
# ============ Volumen N ==========
# Letra asignada:        XXX
# Capacidad (en MB):     XXX
# Espacio libre (en MB): XXX
# Tipo de drive:         XXX [Expresado en cadena de caracteres, según ayuda]
# Sistema de ficheros:   XXX


$cim = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName .
if ($null -eq $cim) {
    Write-Host "Error de conexion"
    exit
}

$computerName = $cim.Name

Write-Host $computerName

$domain = $cim.Domain
$windowsEdition = $cim.Caption
$windowsInstallDate = $cim.InstallDate # InstallDate es de tipo datetime
$windowsDirectory = $cim.WindowsDirectory

$systemType = $cim.SystemType
$systemType = switch ($systemType) {
    1 { "x86" }
    2 { "x64" }
    3 { "Itanium-based" }
    default { "Unknown" }
}

$productType = $cim.ProductType
$productType = switch ($productType) {
    1 { "Workstation" }
    2 { "Domain Controller" }
    3 { "Server" }
    default { "Unknown" }
}

$diskDrive = Get-CimInstance -ClassName Win32_DiskDrive -ComputerName .
$volume = Get-CimInstance -ClassName Win32_Volume -ComputerName .

$fileName = $computerName + "_Info.txt"
$filePath = "C:\Temp"
$fullPath = $filePath + "\" + $fileName

if (Test-Path $fullPath) {
    Write-Host "El fichero ya existe"
    exit
}

if (!(Test-Path $filePath)) {
    Write-Host "El directorio no existe"
    exit
}

$file = New-Item -Path $fullPath -ItemType File
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "------------------------------", "Identificacion del equipo ---------------------------------")
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "Nombre equipo:", "$computerName")
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "Dominio:", "$domain")
Add-Content -Path $fullPath -Value " "
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "------------------------------", "Informacion del sistema operativo -------------------------")
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "Edicion de Windows:", "$windowsEdition")
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "Fecha de instalacion:", "$windowsInstallDate")
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "Directorio de Windows:", "$windowsDirectory")
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "Arquitectura del SO:", "$systemType")
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "Tipo de producto:", "$productType")
Add-Content -Path $fullPath -Value " "
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "------------------------------", "Listado de discos ------------------------------------------")
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "Numero de discos:", "$($diskDrive.Count)")
Add-Content -Path $fullPath -Value " "

if ($diskDrive.Count -is [array] -or $diskDrive.Count -gt 1) {
    for ($i = 0; $i -lt $diskDrive.Count; $i++) {
        $disk = $diskDrive[$i]
        Add-Content -Path $fullPath -Value ("{0,-20} {1,-50}" -f "============", "Disco $i =========")
        Add-Content -Path $fullPath -Value ("{0,-20} {1,-50}" -f "Nombre:", "$($disk.Name)")
        Add-Content -Path $fullPath -Value ("{0,-20} {1,-50}" -f "Modelo:", "$($disk.Model)")
        Add-Content -Path $fullPath -Value ("{0,-20} {1,-50}" -f "Tamano (en GB):", "$($disk.Size / 1GB)")
        Add-Content -Path $fullPath -Value " "
    }
} else {
    Add-Content -Path $fullPath -Value ("{0,-20} {1,-50}" -f "============", "Disco 0 =========")
    Add-Content -Path $fullPath -Value ("{0,-20} {1,-50}" -f "Nombre:", "$($diskDrive.Name)")
    Add-Content -Path $fullPath -Value ("{0,-20} {1,-50}" -f "Modelo:", "$($diskDrive.Model)")
    Add-Content -Path $fullPath -Value ("{0,-20} {1,-50}" -f "Tamano (en GB):", "$($diskDrive.Size / 1GB)")
    Add-Content -Path $fullPath -Value " "
}

Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "-----------------------------",  "Listado de volumenes --------------------------------------")
Add-Content -Path $fullPath -Value ("{0,-30} {1,-60}" -f "Numero de volumenes:", "$($volume.Count)")
Add-Content -Path $fullPath -Value " "

if ($volume.Count -is [array] -or $volume.Count -gt 1) {
    for ($i = 0; $i -lt $volume.Count; $i++) {
        $vol = $volume[$i]
        Add-Content -Path $fullPath -Value ("{0,-25} {1,-40}" -f "=============  Volumen $i", "===============================")
        Add-Content -Path $fullPath -Value ("{0,-25} {1,-40}" -f "Letra asignada:", "$($vol.DeviceID)")
        Add-Content -Path $fullPath -Value ("{0,-25} {1,-40}" -f "Capacidad (en MB):", "$($vol.Capacity / 1MB)")
        Add-Content -Path $fullPath -Value ("{0,-25} {1,-40}" -f "Espacio libre (en MB):", "$($vol.FreeSpace / 1MB)")
        Add-Content -Path $fullPath -Value ("{0,-25} {1,-40}" -f "Tipo de drive:", "$($vol.DriveType)")
        Add-Content -Path $fullPath -Value ("{0,-25} {1,-40}" -f "Sistema de ficheros:", "$($vol.FileSystem)")
    }
}
