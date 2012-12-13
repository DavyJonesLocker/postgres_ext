# Contribution Guidelines #

## Submitting a new issue ##

If you need to open a new issue you *must* provide the following:

1. Version of Rails

Failure to include the aforementioned requirements will result in the
issue being closed.

If you want to ensure that your issue gets fixed *fast* you should
attempt to reproduce the issue in an isolated example application that
you can share.

## Making a pull request ##

If you'd like to submit a pull request please adhere to the following:

1. Your code *must* be tested. Please TDD your code!
2. No single-character variables
3. Two-spaces instead of tabs
4. Single-quotes instead of double-quotes unless you are using string
   interpolation or escapes.
5. General Rails/Ruby naming conventions for files and classes
6. *Do not* use Ruby 1.9 hash syntax
7. *Do not* use Ruby 1.9 stubby proc syntax
8. Follow Tim Pope's [model for git commit messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html). This will make it 
   much easier to generate change logs and navigate through the logs

Please note that you must adhere to each of the aforementioned rules.
Failure to do so will result in an immediate closing of the pull
request. If you update and rebase the pull request to follow the
guidelines your pull request will be re-opened and considered for
inclusion.
