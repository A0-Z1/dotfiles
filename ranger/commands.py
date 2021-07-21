# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command


# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()


class edit_newWindow(Command):
    '''
    open a file in a new OS window and edit it in vis
    '''

    def execute(self):
        if self.arg(1):
            target_filename = self.rest(1)
        else:
            tfile = self.fm.thisfile
            if not tfile:
                self.fm.notify("Error: no file selected!", bad=True)
                return
            files = [f"'{f.relative_path}'" for f in self.fm.thistab.get_selection()]
            target_filename = " ".join(files)

        command = "nohup foot nvim " + target_filename + " > /dev/null 2>&1 &"
        os.system(command)

    def tab(self, tabnum):
        return self._tab_directory_content()


class extract(Command):
    '''
    extract a compressed archive in current dir
    '''

    def execute(self):
        # Indicate the file to extract from the archive
        if self.arg(1):
            to_extract = self.rest(1)
        else:
            to_extract = ""

        # extract the selected archives
        tfile = self.fm.thisfile
        if not tfile:
            self.fm.notify("Error: no file selected!", bad=True)
            return
        files = [f"'{f.relative_path}'" for f in self.fm.thistab.get_selection()]
        target_filename = " ".join(files)

        command = "nohup tar -xzf " + target_filename + " " + to_extract + " &> /dev/null &"
        os.system(command)

    def tab(self, tabnum):
        return self._tab_directory_content()


class compress(Command):
    '''
    compress selected files in current dir
    '''

    def execute(self):
        # Indicate the name of the archive
        if self.arg(1):
            archive = self.rest(1)
        else:
            archive = "archive"

        # compress the selected files
        tfile = self.fm.thisfile
        if not tfile:
            self.fm.notify("Error: no file selected!", bad=True)
            return
        files = [f"'{f.relative_path}'" for f in self.fm.thistab.get_selection()]
        target_filename = " ".join(files)

        command = "nohup tar -czf " + archive + ".tar.gz " + target_filename + " &> /dev/null &"
        os.system(command)

    def tab(self, tabnum):
        return self._tab_directory_content()


class readless(Command):
    '''
    read a pdf on terminal
    '''

    def execute(self):
        if self.arg(1):
            target_file = self.rest(1)
        else:
            target_file = self.fm.thisfile.path

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_file):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        command = f"/home/a0z1/.local/bin/readless '{target_file}'"
        os.system(command)

    def tab(self, tabnum):
        return self._tab_directory_content()
