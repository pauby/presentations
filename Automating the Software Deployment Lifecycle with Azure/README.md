# Automating the Software Deployment Lifecycle with Chocolatey, Jenkins and PowerShell

## Environment Setup

Follow these steps to setup the demo environment:

1. Setup a VM in Azure that has WinRM enabled and that the demo environment Vagrant machine can communicate with. The machine used in my demos is a Windows Server 2016 machine with 1 CPU and 2GB RAM with [Chocolatey installed](https://chocolatey.org/install);
1. Setup an Azure DevOps Artifacts Repository to allow us to create feeds for the demo. See [this blog post](https://blog.pauby.com/post/chocolatey-repository-using-azure-devops-artifacts-feed/) for more information on creating this;
1. Edit the `vagrant-samplesecret.json` file which contains details of what has been setup in Azure. Make sure you rename the file to `vagrant-secret.json`;
1. For the rest of the setup see the [environment setup](https://github.com/pauby/presentations/README.md#environment-setup).

## Presented

This was presented:

* 2 July 2019 - [North East Azure User Group](https://www.meetup.com/North-East-Azure-User-Group/events/261825832/) - [Automating the Software Deployment Lifecycle with Chocolatey, Jenkins and PowerShell](https://github.com/pauby/presentations/tree/master/Automating%20the%20Software%20Deployment%20Lifecycle%20with%20Azure) - [[Slides](https://github.com/pauby/presentations/blob/master/Automating%20the%20Software%20Deployment%20Lifecycle%20with%20Azure/Automating%20the%20Software%20Deployment%20Lifecycle%20with%20Chocolatey%2C%20Jenkins%20and%20PowerShell%20-%2020910702%20-%20North%20East%20Azure%20User%20Group.pdf)] | [[Code](https://github.com/pauby/presentations/tree/master/Automating%20the%20Software%20Deployment%20Lifecycle%20with%20Azure)]

## Resources

* [Getting Started With Chocolatey 4 Business & Jenkins CI](https://blog.pauby.com/post/getting-started-with-chocolatey-and-jenkins/)
* [Build a Chocolatey Package Repository using Azure DevOps Artifacts Feed](https://blog.pauby.com/post/chocolatey-repository-using-azure-devops-artifacts-feed/)
* [Chocolatey Community Repository disclaimer](https://chocolatey.org/docs/community-packages-disclaimer)
* [Chocolatey Documentation](https://chocolatey.org/docs)
* [Gitter Chat](https://gitter.im/chocolatey/choco)
* [Google Groups](https://groups.google.com/forum/#!forum/chocolatey)
* [Learning Resources](https://chocolatey.org/docs/resources)
* [How To Use Package Internalizer To Create Internal Package Source](https://chocolatey.org/docs/how-to-setup-internal-package-repository)