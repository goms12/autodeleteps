function SetRetensiDeletes
{
    Param
    (
        [String]$source, 
        [int]$p_retensi, 
        [String]$format_tanggal
     )

# $format_tanggal = 'yyyy_MM_dd dan yyyy_MM'

    # Create file if not exist
    if (!(test-path D:\Database\log_backup_$(get-date -Format "yyyy_MM").log -PathType Leaf))
    {
        New-Item -Path D:\Database\log_backup_$(get-date -Format "yyyy_MM").log
    }
    #Just condition for me because run this script on every friday.
    if ((Get-Date).DayOfWeek -eq 'Friday')
    {
        for($i=0; $i -le 31; $i++)
        {
            $delete_pattern = (Get-Date).AddDays(-$p_retensi - $i).ToString($format_tanggal)
            $p_file = Get-ChildItem $source -Recurse -Filter *$delete_pattern*
            if($null -ne $p_file)
            {
                ForEach($x_file in $p_file)
                {
                    Remove-Item $x_file.FullName
                    Add-Content D:\Database\log_backup_$(get-date -Format "yyyy_MM").log -Value "`n $(Get-Date -Format yyyy-MM-dd)|$(Get-Date -UFormat %T)|Deleted|$($x_file.FullName)"
                }
            }
        }
    }
}

#Example for function
#Delete files in #source 7 days old
SetRetensiDeletes "\\192.168.XX.XX\backup$" "7" "yyyy_MM_dd"
