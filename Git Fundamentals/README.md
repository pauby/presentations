# Git Fundamentals

Learn the fundamentals of Git to get started in contributing to open source ... and to write better code.

## Presented

This was presented:

* 27 November 2018 - [Newcastle Data Platform and Cloud (DPaC) User Group](https://www.meetup.com/Newcastle_DPaC/events/256028261/) - [Git Fundamentals](https://github.com/pauby/presentations/tree/master/Git%20Fundamentals) - [[Slides](https://github.com/pauby/presentations/blob/master/Git%20Fundamentals/Git%20Fundamentals%20-%2020181127%20-%20DPaC%20UG.pdf)] | [[Code](https://github.com/pauby/presentations/tree/master/Git%20Fundamentals)]

* 15 September 2018 - [French PowerShell Saturday, Paris](https://www.meetup.com/FrenchPSUG/events/247765024/) - [Git Fundamentals](https://github.com/pauby/presentations/tree/master/Git%20Fundamentals) - [[Slides](https://github.com/pauby/presentations/blob/master/Git%20Fundamentals/Git%20Fundamentals.pdf)] | [[Code](https://github.com/pauby/presentations/tree/master/Git%20Fundamentals)] | [[Blog](https://blog.pauby.com/post/speaking-french-powershell-saturday/)]

* 18 January 2018 - [SQL Glasgow User Group](https://sqlglasgow.co.uk) - [Git Fundamentals](https://github.com/pauby/presentations/tree/master/Git%20Fundamentals)] | [[Slides](https://github.com/pauby/presentations/blob/master/Git%20Fundamentals/Git%20Fundamentals%20-%2020180118%20-%20SQL%20Glasgow.pdf)] | [[Code](https://github.com/pauby/presentations/tree/master/Git%20Fundamentals)] | [[YouTube](https://youtu.be/jeBjCC9AAM4 "Git Fundamentals by Paul Broadwith presented at the SQL Glasgow group on 18 January 2018")]

## Resources

### Presentation Links & Stats

* [Chocolatey Package Manager](https://chocolatey.org)
* [Install Chocolatey Package Manager](https://chocolatey.org/install)
* [Wikipedia Definition of Git](https://en.wikipedia.org/wiki/Git)

### Tools

* [Git Tools](http://gitforwindows.org/)
* [Git Credential Manager For Windows](https://github.com/Microsoft/Git-Credential-Manager-for-Windows)
* [Git Extensions](https://gitextensions.github.io/)
* [Git Lens for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
* [GitHub Pull Request Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-pull-request-github)
* [Posh-Git](https://github.com/dahlbyk/posh-git)
* [PSGit](https://github.com/PoshCode/PSGit)

### Git Stats & Use

* [Microsoft Use of Git](https://blogs.msdn.microsoft.com/bharry/2017/05/24/the-largest-git-repo-on-the-planet/)
* [DscResources Repository Statistics](https://blogs.msdn.microsoft.com/powershell/2018/09/13/desired-state-configuration-dsc-planning-update-september-2018/)
* [Companies Using Github](https://github.com/d2s/companies)
* [Government Agencies](https://government.github.com/community/)

### Community - Get Involved!

* [Hacktoberfest](https://hacktoberfest.digitalocean.com/)
* [24 Pull Requests](https://24pullrequests.com/)

### Documentation, Help & Guides

* [Learn Git in your browser](https://try.github.io)
* [Git Documentation and Community](https://git-scm.com)
* [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
* [Think Like A Git](http://think-like-a-git.net/)
* [GitHub Learning Lab Overview](https://www.vgemba.net/github/GitHub-Learning-Lab/)
* [How to keep you fork up to date with the original repository](https://gist.github.com/CristinaSolana/1885435)
* [How to rename a branch](https://www.w3docs.com/snippets/git/how-to-rename-git-local-and-remote-branches.html)
* [How to rollback a commit](https://stackoverflow.com/questions/927358/how-to-undo-last-commits-in-git)
* [An Introduction to Git Merge and Git Rebase: What They Do and When to Use Them](https://medium.freecodecamp.org/an-introduction-to-git-merge-and-rebase-what-they-are-and-how-to-use-them-131b863785f)
* [How to adopt a Git branching strategy](https://medium.freecodecamp.org/adopt-a-git-branching-strategy-ac729ff4f838)
* [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)
* [A Git Workflow for PowerShell Scripting](https://paulcunningham.me/git-workflow-powershell-scripting/)

### Signing Commits 

* [Sign Git Commits Using Keybase](https://www.herebedragons.io/sign-commits-keybase)
    * If you follow this and the command `keybase export --secret` freezing, close the Keybase app and try it again as the command will start it for you.
    * You **need** to configure a custom `gpg` as Git will use the one in it's own directory by default (I believe). [This article](https://gist.github.com/BoGnY/f9b1be6393234537c3e247f33e74094a) tells you about it. Two commands:
        * `git config --global gpg.program "c:/Program Files (x86)/GnuPG/bin/gpg.exe"`
        * `echo 'no-tty' >> ~/.gnupg/gpg.conf`
* [[WINDOWS] How to enable auto-signing Git commits with GnuPG for programs that don't support it natively](https://gist.github.com/BoGnY/f9b1be6393234537c3e247f33e74094a)
