# Se trata de programar un script que permita gestionar un servicio de
# Windows. El servicio se debe gestionar mediante la clase Win32_Service de la infraestructura WMI.
# En este script se gestionan solamente servicios del ordenador local. En primer lugar el script solicita
# al usuario el nombre del servicio que se desea gestionar. Entonces el script determina si el nombre
# introducido corresponde a algún servicio instalado en el sistema. En el caso de que no exista esta
# correspondencia, el script envía a la consola un mensaje indicando el problema y aborta la
# ejecución. En caso de que sí exista, se muestra un menú de opciones indicando las operaciones que
# se pueden llevar a cabo con el servicio. Las opciones se numeran del 1 al 5. El script debe esperar a
# que el usuario introduzca uno de estos números y, a continuación, llevar a cabo la operación
# correspondiente. Una vez realizada la operación, el script termina. El script debe analizar si la
# opción introducida por el usuario es válida, es decir, del 1 al 5. En caso contrario, debe indicar que
# se ha introducido una opción inválida y terminar.

# Las operaciones posibles a realizar con el servicio son las siguientes:

# 1) Obtener una descripción del cometido del servicio
# 2) Indicar el modo de arranque (startmode) del servicio
# 3) Indicar el estado del servicio
# 4) Arrancar el servicio
# 5) Parar el servicio


# Solicitar el nombre del servicio a gestionar
$serviceName = Read-Host "Introduce el nombre del servicio:"

# Obtener instancia del servicio
$service = Get-CimInstance -Query "SELECT * FROM Win32_Service WHERE name = '$serviceName'" -NameSpace root/cimv2

# Comprobar si el servicio existe
if ($null -eq $service) {
    Write-Host "El servicio '$serviceName' no existe en el sistema"
    exit
}

# Menú de opciones
Write-Host "1) Obtener descripción del servicio"
Write-Host "2) Indicar modo de arranque"
Write-Host "3) Indicar el estado del servicio"
Write-Host "4) Arrancar el servicio"
Write-Host "5) Parar el servicio"

# Solicitar opción al usuario
$option = Read-Host "Introduce una opción del 1 al 5"

# Comprobar que la opción es válida
if ($service -lt 1 -or $service -gt 5) {
    Write-Host "La opción introducida no es válida."
    Write-Host "Debe ser un número del 1 al 5"
    exit
}

switch ($option) {
    1 {
        # Mostrar descripción del servicio
        Write-Host "Descripción del servicio: $($service.Descrption)"
    }
    2 {
        # Indicar modo de arranque del servicio
        Write-Host "Modo de arranque: $($service.StartMode)"
    }
    3 {
        # Mostrar el estado del servicio
        Write-Host "Estado del servicio: $($service.State)"
    }
    4 {
        # Arrancar el servicio
        $ret1 = Invoke-CimMethod -InputObject $service -MethodName StartService
        # Comprobar si se ha arancado con éxito
        if ($ret1.ReturnValue -eq 0) {
            Write-Host "El servicio '$serviceName' se ha arrancado con éxito"
        } else {
            Write-Host "Error al arrancar el serivcio '$serviceName'. Error retornado: '$ret1'"
        }
    }
    5 {
        # Parar el servicio
        $ret2 = Invoke-CimMethod -InputObject $service -MethodName StopService
        # Comprobar si se ha parado con éxito
        if ($ret2.ReturnValue -eq 0) {
            Write-Host "El servicio '$serviceName' se ha detenido con éxito"
        } else {
            Write-Host "Error al detener el servicio '$serviceName'. Error retornado: '$ret2'"
        }
    }
}