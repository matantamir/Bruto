param ($FilePath)

function Get-RandomDateBetween{
        <#
        .EXAMPLE
        Get-RandomDateBetween -StartDate (Get-Date) -EndDate (Get-Date).AddDays(15)
        #>
        [Cmdletbinding()]
        param(
            [parameter(Mandatory=$True)][DateTime]$StartDate,
            [parameter(Mandatory=$True)][DateTime]$EndDate
            )

        process{
           return Get-Random -Minimum $StartDate.Ticks -Maximum $EndDate.Ticks | Get-Date -Format d
        }
    }
function Get-RandomTimeBetween{
      <#
        .EXAMPLE
        Get-RandomTimeBetween -StartTime "08:30" -EndTime "16:30"
        #>
         [Cmdletbinding()]
        param(
            [parameter(Mandatory=$True)][string]$StartTime,
            [parameter(Mandatory=$True)][string]$EndTime
            )
        begin{
            $minuteTimeArray = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59")
        }    
        process{
            $rangeHours = @($StartTime.Split(":")[0],$EndTime.Split(":")[0])
            $hourTime = Get-Random -Minimum $rangeHours[0] -Maximum $rangeHours[1]
            $minuteTime = "00"
            if($hourTime -ne $rangeHours[0] -and $hourTime -ne $rangeHours[1]){
                $minuteTime = Get-Random $minuteTimeArray
                return "${hourTime}:${minuteTime}"
            }
            elseif ($hourTime -eq $rangeHours[0]) { # hour is the same as the start time so we ensure the minute time is higher
                $minuteTime = $minuteTimeArray | ?{ [int]$_ -ge [int]$StartTime.Split(":")[1] } | Get-Random # Pick the next quarter
                #If there is no quarter available (eg 09:50) we jump to the next hour (10:00)
                return (.{If(-not $minuteTime){ "${[int]hourTime+1}:00" }else{ "${hourTime}:${minuteTime}" }})               
             
            }else { # hour is the same as the end time
                #By sorting the array, 00 will be pick if no close hour quarter is found
                $minuteTime = $minuteTimeArray | Sort-Object -Descending | ?{ [int]$_ -le [int]$EndTime.Split(":")[1] } | Get-Random
                return "${hourTime}:${minuteTime}"
            }
        }
    }

$Startdate = Get-Date -Date 1/1/2009

$RandomTime = Get-RandomTimeBetween -StartTime "01:15" -EndTime "23:25"
$RandomDate = Get-RandomDateBetween -StartDate $Startdate -EndDate $Startdate.AddDays(3500)
$RandomFixedTime = $RandomDate + " " + $RandomTime + ":23"

$(Get-Item $FilePath).creationtime=$(Get-date -date $RandomFixedTime)
$(Get-Item $FilePath).lastaccesstime=$(Get-date -date $RandomFixedTime)
$(Get-Item $FilePath).lastwritetime=$(Get-date -date $RandomFixedTime)
