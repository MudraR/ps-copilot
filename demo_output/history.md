User: 
Concatenate 24 and 31 in PowerShell
Assistant: 


In PowerShell, you can concatenate numbers by converting them into strings first. Here is how you can concatenate 24 and 31:

```powershell
$number1 = 24
$number2 = 31

$concatenated = $number1.ToString() + $number2.ToString()

Write-Output $concatenated
```

This will output: `2431`

User: 
add 32 to it
Assistant: 


If you want to add 32 to the concatenated number (2431), you can do it like this:

```powershell
$number1 = 24
$number2 = 31
$number3 = 32

$concatenated = $number1.ToString() + $number2.ToString()

$sum = [int]$concatenated + $number3

Write-Output $sum
```

This will output: `2463`

