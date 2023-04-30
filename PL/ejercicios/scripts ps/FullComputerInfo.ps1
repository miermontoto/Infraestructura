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


if (Test-Path $fullPath) {
    Write-Host "El fichero ya existe"
    exit
}
if (!(Test-Path $filePath)) {
    Write-Host "El directorio no existe"
    exit
}

$cim = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName .
if ($cim -eq $null) {
    Write-Host "Error de conexion"
    exit
}

$computerName = $cim.Name

Write-Host $computerName

$domain = $cim.Domain
$windowsEdition = $cim.Caption
$windowsInstallDate = $cim.InstallDate
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

$file = New-Item -Path $fullPath -ItemType File
Add-Content -Path $fullPath -Value "----------------------------- Identificacion del equipo ---------------------------------"
Add-Content -Path $fullPath -Value "Nombre equipo:         $computerName"
Add-Content -Path $fullPath -Value "Dominio:               $domain"
Add-Content -Path $fullPath -Value "----------------------------- Informacion del sistema operativo -------------------------"
Add-Content -Path $fullPath -Value "Edicion de Windows:    $windowsEdition"
Add-Content -Path $fullPath -Value "Fecha de instalacion:  $windowsInstallDate"
Add-Content -Path $fullPath -Value "Directorio de Windows: $windowsDirectory"
Add-Content -Path $fullPath -Value "Arquitectura del SO:   $systemType"
Add-Content -Path $fullPath -Value "Tipo de producto:      $productType"
Add-Content -Path $fullPath -Value "----------------------------- Listado de discos ------------------------------------------"
Add-Content -Path $fullPath -Value "N� de discos:          $($diskDrive.Count)"
if ($diskDrive.Count -is [array] -or $diskDrive.Count -gt 1) {
    for ($i = 0; $i -lt $diskDrive.Count; $i++) {
        $disk = $diskDrive[$i]
        Add-Content -Path $fullPath -Value "============ Disco $i ========="
        Add-Content -Path $fullPath -Value "Nombre:                $($disk.Name)"
        Add-Content -Path $fullPath -Value "Modelo:                $($disk.Model)"
        Add-Content -Path $fullPath -Value "Tama�o (en GB):        $($disk.Size / 1GB)"
    }
} else {
    Add-Content -Path $fullPath -Value "============ Disco 0 ========="
    Add-Content -Path $fullPath -Value "Nombre:                $($diskDrive.Name)"
    Add-Content -Path $fullPath -Value "Modelo:                $($diskDrive.Model)"
    Add-Content -Path $fullPath -Value "Tama�o (en GB):        $($diskDrive.Size / 1GB)"
}

Add-Content -Path $fullPath -Value "----------------------------- Listado de volumenes --------------------------------------"
Add-Content -Path $fullPath -Value "N� de volumenes:       $($volume.Count)"
if ($volume.Count -is [array] -or $volume.Count -gt 1) {
    for ($i = 0; $i -lt $volume.Count; $i++) {
        $vol = $volume[$i]
        Add-Content -Path $fullPath -Value "============ Volumen $i ========="
        Add-Content -Path $fullPath -Value "Letra asignada:        $($vol.DeviceID)"
        Add-Content -Path $fullPath -Value "Capacidad (en MB):     $($vol.Capacity / 1MB)"
        Add-Content -Path $fullPath -Value "Espacio libre (en MB): $($vol.FreeSpace / 1MB)"
        Add-Content -Path $fullPath -Value "Tipo de drive:         $($vol.DriveType)"
        Add-Content -Path $fullPath -Value "Sistema de ficheros:   $($vol.FileSystem)"
    }
}
