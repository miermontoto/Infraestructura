$computer = Get-CimInstance -ClassName Win32_ComputerSystem -Namespace root\cimv2 -ComputerName .
switch ($computer.DomainRole) {
    0 { $role = "Standalone Workstation" }
    1 { $role = "Member Workstation" }
    2 { $role = "Standalone Server" }
    3 { $role = "Member Server" }
    4 { $role = "Backup Domain Controller" }
    5 { $role = "Primary Domain Controller" }
}
Write-Host "Nombre de equipo: $($computer.Name)"
Write-Host "Dominio: $($computer.Domain)"
Write-Host "Rol en el dominio: $role"
