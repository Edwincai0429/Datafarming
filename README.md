### SETUP

You will need to have Ruby v2.0 or later installed on your system.  On OS X, Ruby comes pre-installed.  For Windows we recommend the installer packages available from [rubyinstaller.org](http://rubyinstaller.org/).  You will need to determine whether your have a 32 or 64 bit processor, and download the appropriate installer.  We currently are recommending Ruby v2.2.X due to its stability and speed.  When installing, check the checkboxes to add the Ruby installation to your PATH and to associate `.rb` and `.rbw` files with Ruby&mdash;doing so will make your life simpler going forward.

Several of these scripts use Ruby gems.  Please run the command:

    gem install quickstats fwt colorize

before attempting to run the scripts in this distribution.  On OS X or Linux systems, you may be required to prefix the `gem install...` command with `sudo` to authenticate the installation.

### USAGE

Ruby is a powerful and concise interpreted object-oriented scripting language.  Scripts are run from a command-line or terminal environment by typing the `ruby` command followed by a script name, often followed by one or more command-line arguments.  For example, typing

    ruby stripheaderdups.rb my_file.txt

will invoke the `stripheaderdups.rb` script and apply it to file `my_file.txt` in the current working directory.

All scripts in this distribution are self describing if run with a `--help`, `-h`, or `-?` option.

### EXECUTE FROM ANYWHERE (OPTIONAL)

To be able to execute these shell scripts regardless of where you are working, you will need to add the directory where they reside to the system `PATH` environment variable.  The mechanism for doing so depends on your system. The changes described below only need to be performed one time.

#### OS X

On an OS X machine, you need to update the PATH using the `.bash_profile` configuration file which resides in your home directory.  For instance, if I have downloaded these scripts to `~/DataFarming/UsefulRubyScripts`, then I would use a text editor to add the following lines to `~/.bash_profile`:

    if [ -d ~/DataFarming/UsefulRubyScripts ]; then
       PATH="${PATH}:~/DataFarming/UsefulRubyScripts"
    fi
    export PATH

Finally, make sure that the ruby scripts are all executable:

    chmod a+x ~/DataFarming/UsefulRubyScripts/*.rb

#### WINDOWS

The details for setting the `PATH` environment variable are different for different versions of the Windows operating system.  The following assumes that you have put these tools in a folder called `C:\UsefulRubyScripts` on a Windows 10 system:

  1. Open Windows "Settings".

  2. Drill down through the series of menu options and popup panels:
       `Settings -> System -> About -> System info -> Advanced system settings`

  3. Click on the `Environment Variables` button

  4. Select the `Path` line, and click `Edit...`

  5. Click the `New` button, and enter `C:\UsefulRubyScripts` in the resulting field.

  6. Click `OK` to accept the input, click `OK` to close the panel, and close everything.

If all went well, you should be able to open a `CMD.EXE` window, type `PATH` followed by a return, and see `C:\UsefulRubyScripts` as an element of the `PATH` string.
