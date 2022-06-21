configuration PSConfEU2022Demo {

    Import-DscResource -ModuleName cChoco

    Node 'localhost' {

        # install Chocolatey CLI
        cChocoInstaller installChoco {
            InstallDir = "$($env:ProgramData)\chocolatey"
            DependsOn  = '[Environment]chocolateyDownloadUrl'
        }

        # remove the Chocolatey Community Repository
        cChocoSource removeChocolateySource {
            Name   = 'chocolatey'
            Ensure = 'absent'
        }

        # set the Chocolatey cache location
        cChocoConfig setCacheLocation {
            ConfigName = 'cacheLocation'
            Ensure     = 'present'
            Value      = "$($env:ProgramData)\chocolatey\choco-cache"
        }

        # set the command execution timeout
        cChocoConfig setCommandExecutionTimeout {
            ConfigName = 'commandExecutionTimeoutInSeconds'
            Ensure     = 'present'
            Value      = 1200
        }

        # not recommended for organizations
        cChocoConfig useVirusTotal {
            ConfigName = 'virusScannerType'
            Ensure     = 'present'
            Value      = 'virustotal'
        }

        # enable global confirmation so you don't have to add -y each time you run
        cChocoFeature enableAllowGlobalConfirmation {
            FeatureName = 'allowGlobalConfirmation'
            Ensure      = 'present'
        }

        # you don't want your package installs to be skipped because a reboot is needed
        cChocoFeature disableExitOnRebootDetected {
            FeatureName = 'exitOnRebootDetected'
            Ensure      = 'absent'
        }

        # remembers the package parameters used at install and uses them for upgrades too
        cChocoFeature enableUseRememberedArgumentsForUpgrades {
            FeatureName = 'useRememberedArgumentsForUpgrades'
            Ensure      = 'present'
        }

        # enables downloading from the private CDN if the file is found there
        cChocoFeature enableDownloadCache {
            FeatureName = 'allowGlobalConfirmation'
            Ensure      = 'present'
        }

        # allows preview functionality to be used
        cChocoFeature enableAllowPreviewFeatures {
            FeatureName = 'allowPreviewFeatures'
            Ensure      = 'present'
        }

        # keep installed Chocolatey packages in sync with changes in Programs and Features
        cChocoFeature enableAllowSynchronization {
            FeatureName = 'allowSynchronization'
            Ensure      = 'present'
        }

        # fail if package does not include checksums for files downloaded via http
        cChocoFeature disableUseEmptyChecksums {
            FeatureName = 'useEmptyChecksums'
            Ensure      = 'absent'
        }

        # fail if package does not include checksums for files downloaded via https
        cChocoFeature disableUseEmptyChecksumsSecure {
            FeatureName = 'useEmptyChecksumsSecure'
            Ensure      = 'absent'
        }

        # enable virus check of downloaded files (licensed edition only)
        cChocoFeature enableVirusCheck {
            FeatureName = 'virusCheck'
            Ensure      = 'present'
        }
    }
}

$config = PSConfEU2022Demo
Start-DscConfiguration -Path $config.psparentpath -Wait -Verbose -Force