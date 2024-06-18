$MODEL = 'gpt-4-0613'
# 'copilot-chat'
# 'gpt-4-0613'

$token = $null
$messages = @()

function SetOAuth {
    $headers = @{
        'accept' = 'application/json'
        'editor-version' = 'Neovim/0.10.0'
        'editor-plugin-version' = 'copilot.vim/1.36.0'
        'content-type' = 'application/json'
        'user-agent' = 'GithubCopilot/1.80.0'
        'accept-encoding' = 'gzip,deflate,br'
    }
    $body = @{
        'client_id' = 'Iv1.b507a08c87ecfe98'
        'scope' = 'read:user'
    } | ConvertTo-Json

    $resp = Invoke-RestMethod -Uri 'https://github.com/login/device/code' -Method Post -Headers $headers -Body $body

    $device_code = $resp.device_code
    $user_code = $resp.user_code
    $verification_uri = $resp.verification_uri

    Write-Host "Open $verification_uri in your browser and enter code $user_code to authenticate (you may have to sign in again)."

    while ($true) {
        Start-Sleep -Seconds 5
        $body = @{
            'client_id' = 'Iv1.b507a08c87ecfe98'
            'device_code' = $device_code
            'grant_type' = 'urn:ietf:params:oauth:grant-type:device_code'
        } | ConvertTo-Json

        $resp = Invoke-RestMethod -Uri 'https://github.com/login/oauth/access_token' -Method Post -Headers $headers -Body $body

        $access_token = $resp.access_token

        if ($access_token) {
            break
        }
    }

    Set-Content -Path 'ghCopilotToken.txt' -Value $access_token

    Write-Host 'Authentication success!'
}

function GetSessionToken {
    $script:token = $null

    while ($true) {
        try {
            $access_token = Get-Content -Path 'ghCopilotToken.txt' -ErrorAction Stop
            break
        }
        catch {
            if ($_.Exception -is [System.Management.Automation.ItemNotFoundException]) {
                SetOAuth
            }
        }
    }

    $headers = @{
        'authorization' = "token $access_token"
        'editor-version' = 'Neovim/0.10.0'
        'editor-plugin-version' = 'copilot.vim/1.36.0'
        'user-agent' = 'GithubCopilot/1.80.0'
    }

    $resp = Invoke-RestMethod -Uri 'https://api.github.com/copilot_internal/v2/token' -Method Get -Headers $headers

    $script:token = $resp.token
}

function Chat {
    param (
        [Parameter(Mandatory=$true)]
        [string]$message
    )

    if ($null -eq $script:token) {
        GetSessionToken
    }

    $userMessage = @{
        'content' = $message
        'role' = 'user'
    }
    $script:messages += $userMessage

    # Save user message to history
    Add-Content -Path 'history.md' -Value ("User: `n" + $message)

    $headers = @{
        'authorization' = "Bearer $($script:token)"
        'Host' = "api.githubcopilot.com"
        'Editor-Version' = "vscode/1.84.2"
        'editor-plugin-version' = 'copilot.vim/1.36.0'
        'Openai-Organization' = "github-copilot"
        'Openai-Intent' = "conversation-inline"
        'Content-Type' = "application/json"
        'user-agent' = 'GithubCopilot/1.80.0'
        'Accept' = "*/*"
        'Accept-Encoding' = "gzip, deflate, br"
    }

    $body = @{
        'intent' = $false
        'model' = $MODEL
        'max_tokens' = 100
        'temperature' = 0
        'top_p' = 1
        'n' = 1
        'stream' = $true
        'logprobs' = $true
        'messages' = $script:messages
    } | ConvertTo-Json

    try {
        $resp = Invoke-RestMethod -Uri 'https://api.githubcopilot.com/chat/completions' -Method Post -Headers $headers -Body $body
    }
    catch {
        return ''
    }

    $result = ($resp -split '\n' | Where-Object { $_.StartsWith('data: {') } | ForEach-Object {
        $json_completion = $_.Substring(6) | ConvertFrom-Json
        $completion = $json_completion.choices[0].delta.content
        if ($completion) { $completion } else { "`n" }
    }) -join ''

    $assistantMessage = @{
        'content' = $result
        'role' = 'assistant'
    }
    $script:messages += $assistantMessage

    # Save assistant message to history
    Add-Content -Path 'history.md' -Value ("Assistant: `n" + $result)


    if ($result -eq '') {
        Write-Host $resp.StatusCode
        Write-Host $resp.Content
    }

    return $result
}

# Chat -message "Your message here"

function Main {
    GetSessionToken
    while ($true) {
        Write-Host -NoNewline -ForegroundColor Cyan 'Ask Copilot: '
        $inputMessage = Read-Host
        $response = Chat -message $inputMessage
        Write-Host -NoNewline -ForegroundColor Green "Copilot: "
        Write-Host $response
    }
}

Main
