#
# Setup
#
# Can everybody see the code okay?
#
rm function:prompt # remove it just in case posh-git detects it as a custom one
Import-Module posh-git -Force
$GitPromptSettings.DefaultPromptPrefix = '`n`n'
$rootPath = 'C:\gitfundamentalstalk'
$myRepoPath = 'git-fundamentals-demo'
$contributorRepoPath = 'git-fundamentals-demo-contributor'
$forkRepoPath = 'fork-git-fundamentals-demo'
New-Item -Path $rootPath -ItemType Directory -ErrorAction SilentlyContinue
Set-Location $rootPath
#Remove-Item * -Force -Recurse
Write-Host "`n`nCan everybody see the code okay?`n`n" -foregroundcolor green

#
# Clone the demo repository
#

git clone https://github.com/psdevopsug/git-fundamentals-demo
git clone https://github.com/psdevopsug/git-fundamentals-demo git-fundamentals-demo-contributor
Set-Location (Join-Path -Path $rootPath -ChildPath $myRepoPath)

# Check the status

Get-ChildItem
git status
git remote
git remote -v

#
# We are another contributor and added some aliases
# cd c:\windows
# ==============================================

Set-Location (Join-Path -Path $rootPath -ChildPath $contributorRepoPath)
Set-Content -Path 'setup.ps1' -Value 'cd c:\windows'
git add setup.ps1
git commit -m 'Add setup file'
git push

#
# Move to our repository
# =======================

# A colleague has added some code to the repository
start-process 'https://github.com/psdevopsug/git-fundamentals-demo'

Set-Location (Join-Path -Path $rootPath -ChildPath $myRepoPath)

# Check the status
git status
Get-ChildItem
git remote -v

# Lets pull down the changes
git pull

# Lets have a look at the files now in our repository
Get-ChildItem

# Open the setup.ps1 file and the alias 'ls'
code setup.ps1

# Now lets see the status, stage and commit this change
git status

# Lets add the file, using a dot this time
git add .
git status

# Lets commit this and push it
git commit -m 'Add directory list'
git push

# Lets look at this on the site
start-process 'https://github.com/psdevopsug/git-fundamentals-demo'


#
# Forking and Pull Request
# =========================

# Fork the repository to pauby
start-process 'https://github.com/psdevopsug/git-fundamentals-demo'

Set-Location $rootPath
git clone https://github.com/pauby/git-fundamentals-demo $forkRepoPath
Set-Location (Join-Path -Path $rootPath -ChildPath $forkRepoPath)

# We need to set the original repository we will call the upstream
git remote -v
git remote add upstream https://github.com/psdevopsug/git-fundamentals-demo
git remote -v

# We want to make a change and create a new branch
git status
git checkout -b remove-aliases
git status
Get-ChildItem

# Lets update the code to change the aliases
code setup.ps1

# Let's check the status, stage the files and then commit them
git status
git add .
git status

# Lets commit
git commit -m 'Remove aliases'
git push
git remote -v
git push --set-upstream origin remove-aliases

# Go to the forked repository and raise a pull request

# Now go to the fork and raise a pull request from remove-aliases to master
start-process 'https://github.com/pauby/git-fundamentals-demo'

#
# Now the upstream repository is updated but we much update our fork
#

# change to the master branch
git checkout master

# pull down the changes from the upstream master branch
git pull upstream master

# Now lets look at the file
code setup.ps1

# check our master branch on Github - see it does not have the changes
start-process 'https://github.com/pauby/git-fundamentals-demo'

# push those changes
git push origin