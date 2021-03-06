### SETUP

You will need to have Ruby v2.0 or later installed on your system.  On MacOS, Ruby comes pre-installed.  For Windows we recommend the installer packages available from [rubyinstaller.org](http://rubyinstaller.org/).  You will need to determine whether your have a 32 or 64 bit processor, and download the appropriate installer.  We recommend Ruby v2.4.x for Windows users, as it is substantially faster than prior versions.  When running the installer, check the checkboxes to add the Ruby installation to your PATH and to associate `.rb` and `.rbw` files with Ruby.  

You can test your installation by opening `Terminal.app` (MacOS) or `CMD.EXE` (Windows) and typing `ruby --version` (note there are two dashes).  You should see a response telling you which version of Ruby you are running.

Several of these scripts use Ruby packages known as "gems."  Please open `Terminal.app` (MacOS) or `CMD.EXE` (Windows) and run the command:

    gem install quickstats fwt colorize

before attempting to run the scripts in this distribution.  On MacOS or Linux systems, you may be required to use the `sudo` command to to authenticate the installation.  In that case, type `sudo gem install quickstats fwt colorize` and enter your password when prompted.

### USAGE

Ruby is a powerful and concise  object-oriented scripting language.  Scripts are run from a command-line or terminal environment by typing the `ruby` command followed by a script name, often followed by one or more command-line arguments.  For example, typing

    ruby stripheaderdups.rb my_file.txt

will invoke the `stripheaderdups.rb` script and apply it to file `my_file.txt` in your current working directory.

All scripts in this distribution are self documenting if run with a `--help`, `-h`, or `-?` option.

### EXECUTE FROM ANYWHERE

To be able to execute these shell scripts regardless of where you are working, you will need to add the directory where they reside to the system `PATH` environment variable.  The mechanism for doing so depends on your system. The changes described below only need to be performed one time.

#### MacOS

On a MacOS machine, you need to update the PATH environment variable by editing your `.bash_profile` configuration file, which resides in your home directory.

Note that:

  1. you can display "hidden" files such as .bash_profile from the `File -> Open` menu of most text editors by typing `Command-Shift-.` (note the period at the end!) to make the hidden files visible;

  2. the symbol `~` is Unix shorthand for your home directory; and

  3. in the following example, you must change ***all*** references to the location if you download your copy to a different name or location.

As an example, if these scripts were downloaded to `~/datafarmingrubyscripts` you can use your favorite text editor to add the following lines to `~/.bash_profile`:

    if [ -d ~/datafarmingrubyscripts ]; then
      PATH="${PATH}:~/datafarmingrubyscripts"
    fi
    export PATH

Finally, enter the following command ***one time*** in a terminal window to make sure that the ruby scripts are all executable:

    chmod a+x ~/datafarmingrubyscripts/*.rb

As before, you must change the directory reference if you downloaded the scripts to a different location.

#### WINDOWS

The details for setting the `PATH` environment variable are different for different versions of the Windows operating system.  The following example assumes that you are working on a Windows 10 system, and that you have downloaded these scripts to the folder `C:\datafarmingrubyscripts`.  If you have cloned the repository to a different name or location, you ***must*** change information in step 5 below to reflect the correct location.

  1. Open Windows `Settings`.

  2. Drill down through the series of menu options and popup panels:
       `Settings -> System -> About -> System info -> Advanced system settings`

  3. Click on the `Environment Variables` button

  4. Select the `Path` line, and click `Edit...`

  5. Click the `New` button, and enter `C:\datafarmingrubyscripts` in the resulting field.

  6. Click `OK` to accept the input, click `OK` to close the panel, and close everything.

If all went well, you should be able to open a `CMD.EXE` window, type `PATH` followed by a return, and see `C:\datafarmingrubyscripts` as an element of the `PATH` string.
