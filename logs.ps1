# script3.ps1
#definición de la función New-FolderCreation
function New-FolderCreation {
    [CmdletBinding()]
#define los parámetros
    param(
        [Parameter(Mandatory = $true)]
#define que el parámetro folder será obligatorio
        [string]$foldername
#señala que el fondename será un string
    )

    #Crear la ruta completa combinando la ubicación actual con el nombre de la carpeta
    $logpath = Join-Path -Path (Get-Location).Path -ChildPath $foldername
#verificar si la carpeta NO EXISTE
    if (-not (Test-Path -Path $logpath)) {
# Crear la carpeta y ocultar la salida
        New-Item -Path $logpath -ItemType Directory -Force | Out-Null
    }
# Devolver la ruta completa creada
    return $logpath
}

# Definición de la función Write-Log
function Write-Log {
    [CmdletBinding()]
    param(

# Nombre o nombres de archivo a crear (acepta string o array)
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [Alias('Names')]
        [object]$Name,

# Extensión del archivo obligatoria en el grupo Create
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$Ext,

# Carpeta donde se guardarán los archivos
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$folder,

# Switch que activa el modo Create
        [Parameter(ParameterSetName = 'Create', Position = 0)]
        [switch]$Create,

# Mensaje a escribir en un archivo
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$message,

# Ruta del archivo donde se guardará el mensaje
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$path,

# Severidad del mensaje (solo acepta los valores del ValidateSet)
        [Parameter(Mandatory = $false, ParameterSetName = 'Message')]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information',

# Switch que activa el modo MSG
        [Parameter(ParameterSetName = 'Message', Position = 0)]
        [switch]$MSG
    )
# Switch para seleccionar qué conjunto de parámetros se está usando
    switch ($PsCmdlet.ParameterSetName) {
#entrar en modo create
        "Create" {

# Arreglo donde se almacenarán las rutas creadas
            $created = @()

# Normalizar $Name a un array para poder recorrerlo siempre
            $namesArray = @()
            if ($null -ne $Name) {
# Si es array, usarlo tal cual
                if ($Name -is [System.Array]) { $namesArray = $Name }
# Si es string, convertirlo en array de un elemento
                else { $namesArray = @($Name) }
            }

# Obtener fecha en formato seguro para nombres de archivo
            $date1 = (Get-Date -Format "yyyy-MM-dd")
# Obtener hora en formato seguro para nombres de archivo
            $time  = (Get-Date -Format "HH-mm-ss")

# Crear la carpeta si no existe y obtener su ruta absoluta
            $folderPath = New-FolderCreation -foldername $folder

# Recorrer cada nombre solicitado
            foreach ($n in $namesArray) {

# Convertir nombre a string
                $baseName = [string]$n

# Construir el nombre final del archivo (ejemplo: Log_2025-01-01_12-00-00.txt)
                $fileName = "${baseName}_${date1}_${time}.$Ext"

# Crear la ruta completa del archivo
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName

# Intentar crear el archivo
                try {
# Crear o sobrescribir el archivo, ocultando la salida
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null

# Agregar la ruta del archivo al listado de creados
                    $created += $fullPath
                }
                catch {
# Mostrar advertencia si no se pudo crear el archivo
                    Write-Warning "Failed to create file '$fullPath' - $_"
                }
            }
# Devolver lista de rutas creadas
            return $created
        }

 #Entrar a modo message
        "Message" {

# Obtener la carpeta donde se guardará el archivo
            $parent = Split-Path -Path $path -Parent

# Crear la carpeta si no existe
            if ($parent -and -not (Test-Path -Path $parent)) {
                New-Item -Path $parent -ItemType Directory -Force | Out-Null
            }

# Obtener fecha actual
            $date = Get-Date

# Construir la línea de mensaje completa
            $concatmessage = "|$date| |$message| |$Severity|"

# Mostrar mensaje en colores dependiendo de la severidad
            switch ($Severity) {
                "Information" { Write-Host $concatmessage -ForegroundColor Green }
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow }
                "Error"       { Write-Host $concatmessage -ForegroundColor Red }
            }

# Agregar el mensaje al archivo, creándolo si no existe
            Add-Content -Path $path -Value $concatmessage -Force

# Devolver la ruta del archivo donde se escribió el mensaje
            return $path
        }
# Si no es ninguno de los modos válidos, lanzar excepción
        default {
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)"
        }
    }
}

#Ejemplo

# Crear un archivo de log dentro de una carpeta "logs"
# El nombre generado incluirá: nombre, fecha y hora
$logPaths = Write-Log -Name "Name-Log" -folder "logs" -Ext "log" -Create

# Mostrar las rutas de los archivos creados
$logPaths