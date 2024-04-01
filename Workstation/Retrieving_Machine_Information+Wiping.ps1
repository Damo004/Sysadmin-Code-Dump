# Path to the Excel file
$csvFilePath = "D:\Customer_Info.csv"

# Function to retrieve computer information and append to Excel
function Get-ComputerInfoAndAppendToExcel {

    # Get computer information
    $username = Read-Host "Input the old users name"
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
    $serialNumber = Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty SerialNumber
    $cpuInfo = Get-CimInstance -ClassName Win32_Processor
    $ramSticks = Get-CimInstance -ClassName Win32_PhysicalMemory

    # Calculate total RAM capacity in GB
    $totalRamCapacity = $ramSticks | Measure-Object -Property Capacity -Sum | Select-Object -ExpandProperty Sum
    $totalRamCapacityGB = [math]::Round($totalRamCapacity / 1GB, 2)

    # Create an object to hold the data
    $data = [PSCustomObject]@{
        Username = $username
        ComputerName = $computerSystem.Name
        Model = $computerSystem.Model
        SerialNumber = $serialNumber
        CPUName = $cpuInfo.Name
        TotalRAMCapacityGB = $totalRamCapacityGB
    }

    # Append data to the Excel file
    $data | Export-Csv -Path $csvFilePath -Append -NoTypeInformation

    Write-Host "Computer information has been appended to Excel sheet."
}

Get-ComputerInfoAndAppendToExcel

Write-Host "Information appended to Excel sheet."

# Remove from Domain 
Remove-Computer -UnjoinDomainCredential $credential -Force

# Start the reset process
$resetProcess = Start-Process "C:\Windows\System32\systemreset.exe" -ArgumentList "--factoryreset"

# Wait for the reset process to finish
$resetProcess.WaitForExit()
