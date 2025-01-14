# Update File On Github Powershell Script
A simple powershell script to update file contents.

This PowerShell script allows you to update a file in a GitHub repository using the GitHub API. It supports passing commands or content as arguments, making it flexible for automation and shortcuts.
It is usefull if you want to pass simple info text to some files or update file contents from desktop quickly. 

----------

## **Features**

-   Update a file in a GitHub repository.    
-   Pass commands (e.g.,  `update`,  `delete`) or custom content as arguments.
-   Create shortcuts to run the script with specific commands.    
-   Error handling and debugging information.
   

----------

## **Prerequisites**

1.  **GitHub Access Token**:
    
    -   Generate a personal access token with the  `repo`  scope.        
    -   Follow the steps in the script's header or  [GitHub's guide](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).
        
2.  **PowerShell**:
    -   Ensure PowerShell is installed on your system (Windows includes it by default).
        
----------

## **Setup**

### **1. Clone the Repository**

Clone this repository to your local machine:



    git clone https://github.com/limbo666/Update_File_On_Github_Powershell_Script.git

### **2. Configure the Script**

Open the script file (`update-github-file.ps1`) and modify the following variables in the  **CONFIGURATION SECTION**:


    $GithubToken = "your_github_token_here"        				 # Your GitHub personal access token
    $RepoOwner = "github_username"               				 # Your GitHub username
    $RepoName = "Update-Github-File"  					 # Your repository name
    $FilePath = "docs/test.txt"                     			 # Path to the file in the repository
    $CommitMessage = "Updated file content from script"                      # Commit message
    $DefaultContent = "No Text Provided"           			         # Default content if no argument is provided

----------

## **Usage**

### **Run the Script**

You can run the script directly from PowerShell or create shortcuts to pass commands.

#### **Basic Usage**

Update the file with default content:

    .\update-github-file.ps1

#### **Update with Custom Content**

Pass the content as an argument:

    .\update-github-file.ps1 "This is new content"

#### **Commands**

Pass a command as an argument:

    .\update-github-file.ps1 "update"
    .\update-github-file.ps1 "delete"

----------

### **Create Shortcuts**

You can create shortcuts to run the script with specific commands or content.

#### **Steps to Create a Shortcut**

1.  Right-click on your desktop or in a folder and select  **New > Shortcut**.
    
2.  In the "Type the location of the item" field, enter:
      
    `powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\update-github-file.ps1" "argumen`t"
    
    Replace  `"C:\path\to\update-github-file.ps1"`  with the full path to the script and  `"argument"`  with the command or content 
