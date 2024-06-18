# ps-copilot
PowerShell script for interacting with the not-so-public public GitHub Copilot API featuring a CLI interface for asking questions and receiving responses with conversation history

### Context
At this time, GitHub Copilot is private and there is no obviously open-to-the-public API. However, GitHub Copilot offers the GitHub copilot extension to various IDEs. To use the IDE, you have to login into GitHub through your browser using the copilot extension. The extensions then use the "public" copilot endpoints to bring answsers back to you. 

>_Note:_ You still need a GitHub Copilot license to be able to use this tool


### Step 1: Generate user-to-server GitHub token
The `SetOAuth` function in the PowerShell script will hit the https://github.com/login/device/code and give you a device code to oauth as a device. This generates a [user-to-server](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/authenticating-with-a-github-app-on-behalf-of-a-user) token with the `ghu_xxx` prefix and save it to the ghCopilotToken.txt file to the directory you're running the script from. 

### Step 2: Talk to GitHub Copilot from the comfort of your terminal!
As you can see in the image below, just run the script `./copilot_cli.ps1` and start asking questions! 

The history will be saved in the `history.md` file in pretty markdown format!

![demo](https://github.com/MudraR/ps-copilot/blob/main/demo_output/demo.png)

### Step 3: Manipulate the model
You can play around with the body and update params like `max_tokens`, `temperature`, `messages`, etc. The benefit of having GitHub copilot in a script is that you can learn as you go and change as much as you want to test. Since copilot is a joint collab between OpenAI and Microsoft, Copilot isn't just locked down to the codex model! You can switch to the `gpt-4-0613` model, and potentially many more. I've sourced a few models that may be available to switch to:

#### Potentially available models to test with

| Model                          | Owner        |
|-----------------------------|-----------------|
| text-search-babbage-doc-001 | openai-dev      |
| gpt-4-0613                  | openai          |
| gpt-4                       | openai          |
| babbage                     | openai          |
| gpt-3.5-turbo-0613          | openai          |
| text-search-babbage-doc-001 | openai-dev      |
| gpt-4-0613                  | openai          |
| gpt-4                       | openai          |
| babbage                     | openai          |
| gpt-3.5-turbo-0613          | openai          |
| text-babbage-001            | openai          |
| gpt-3.5-turbo               | openai          |
| gpt-3.5-turbo-1106          | system          |
| curie-instruct-beta         | openai          |
| gpt-3.5-turbo-0301          | openai          |
| gpt-3.5-turbo-16k-0613      | openai          |
| text-embedding-ada-002      | openai-internal |
| text-search-babbage-doc-001 | openai-dev      |
| gpt-4-0613                  | openai          |
| gpt-4                       | openai          |
| babbage                     | openai          |
| gpt-3.5-turbo-0613          | openai          |
| text-babbage-001            | openai          |
| gpt-3.5-turbo               | openai          |
| gpt-3.5-turbo-1106          | system          |
| curie-instruct-beta         | openai          |
| gpt-3.5-turbo-0301          | openai          |
| gpt-3.5-turbo-16k-0613      | openai          |
| text-embedding-ada-002      | openai-internal |
| davinci-similarity          | openai-dev      |
| curie-similarity            | openai-dev      |
| babbage-search-document     | openai-dev      |
| curie-search-document       | openai-dev      |
| babbage-code-search-code    | openai-dev      |
| ada-code-search-text        | openai-dev      |
| text-search-curie-query-001 | openai-dev      |
| text-davinci-002            | openai          |
| ada                         | openai          |
| text-ada-001                | openai          |
| ada-similarity              | openai-dev      |
| code-search-ada-code-001    | openai-dev      |
| text-similarity-ada-001     | openai-dev      |
| text-davinci-edit-001       | openai          |
| code-davinci-edit-001       | openai          |
| text-search-curie-doc-001   | openai-dev      |
| text-curie-001              | openai          |
| curie                       | openai          |
| davinci                     | openai          |
| gpt-4-0314                  | openai          |
