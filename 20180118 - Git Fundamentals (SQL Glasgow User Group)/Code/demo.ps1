#
# Setup
#
# Can everybody see the code okay?
#
break
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

# ===========================================
#
# DEMO 1
#
# ===========================================

# Lets have a look at the code on GitHub
Start-Process 'https://github.com/psdevopsug/git-fundamentals-demo'

# Clone the remote repository
git clone https://github.com/psdevopsug/git-fundamentals-demo
#git clone https://github.com/psdevopsug/git-fundamentals-demo git-fundamentals-demo-contributor
cd (Join-Path -Path $rootPath -ChildPath $myRepoPath)

# Lets have a look at what is in there
ls

# Lets have a look at the remote URL(s)
git remote              # not helpful
git remote --verbose    # helpful

# ===========================================
#
# DEMO 2
#
# ===========================================

# Check the status
ls
git status

# Lets make a change to the repository - update a file
Set-Content -Path 'setup.ps1' -Value 'gci c:\windows'

# Lets look at the status of the repository now
git status
git diff setup.ps1

# Lets add this new file to the staging area and have a look at the status
git add setup.ps1
git status

# Lets commit this new file to the
git commit --message 'Add setup file'
git push origin

# Lets have a look at the code on GitHub
Start-Process 'https://github.com/psdevopsug/git-fundamentals-demo'

# ===========================================
#
# DEMO 3 - Branching
#
# ===========================================

# Check the status
git status

# Create a branch
git checkout -b fix-alias

# Check the status
git status

# Look at the setup.ps1 and change the alias gci to Get-ChildItem
code setup.ps1

# Check the status
git status

# Get the differences
git diff

# Add all of the changes to staged
git add .

# Check the status
git status

# Commit and push it
git commit --message 'Removed the alias'
git push origin     # we get an error message!

# Push the commit to the correct remote
git push --set-upstream origin fix-alias

# Lets have a look at the code on GitHub
# and the different branches
# see how different branches can have different code
Start-Process 'https://github.com/psdevopsug/git-fundamentals-demo'

# ===========================================
#
# DEMO 4 - Forking and Pull Request
#
# ===========================================

# check the remote URL's
git remote --verbose

# Fork the repository to pauby
start-process 'https://github.com/psdevopsug/git-fundamentals-demo'

cd $rootPath
git clone https://github.com/pauby/git-fundamentals-demo $forkRepoPath
cd (Join-Path -Path $rootPath -ChildPath $forkRepoPath)

# We need to set the original repository we will call the upstream
git remote -v
git remote add upstream https://github.com/psdevopsug/git-fundamentals-demo
git remote -v

# We want to make a change and create a new branch
git status
git checkout -b pipe-output
git status
ls

# Lets update the code to add ` | Out-File setup.log`
code setup.ps1

# Let's check the status, stage the files and then commit them
git status
git add .
git status

# Lets commit
git commit -m 'Add loggin'
git push
git remote -v
git push --set-upstream origin pipe-output

# Now go to the fork and raise a pull request from remove-aliases to master
start-process 'https://github.com/pauby/git-fundamentals-demo'

#
# Now the upstream repository is updated but we must update our fork
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

# lets see those changes after the push
Start-Process 'https://github.com/pauby/git-fundamentals-demo'
