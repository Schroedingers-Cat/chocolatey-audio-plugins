# Helper functions for handling text files

function CreateTxtFiles ($txtFileObject) {
    if($txtFileObject.execute -eq $true) {
      Write-Debug ("Creating txt file in " + $txtFileObject.key + " with the content: " + $txtFileObject.value)
      Remove-Item $txtFileObject.key -ErrorAction SilentlyContinue
      New-Item $txtFileObject.key -ItemType file -Force
      [System.IO.File]::WriteAllLines($txtFileObject.key, $txtFileObject.value, (New-Object ("System.Text." + $txtFileObject.encoding + "Encoding") $txtFileObject.bom))
    }
  }
  