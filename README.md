# *cl-marklogic*
*cl-marklogic* is a *Common Lisp* system for working with *MarkLogic Server* clusters. There is a stable version of *cl-marklogic* in the *QuickLisp* repository.

*ml-optimizer* [Demonstration](http://opsresearch.com/demo/ml-optimizer/).

Tested with *MarkLogic Server* 8.
Tested with *SBCL* and *ABCL*.

# Quick Start

This quick tutorial shows you how to run some simple examples using *cl-marklogic*. It is written to use *SBCL*, and *QuickLisp* on *OSX*. If you are using a different operating system you will need to adjust some details but the overall steps will be the same.

* [Install *Homebrew*](http://brew.sh) if it isn't installed on your computer. 

* Install *SBCL*.
    `brew update`
    `brew install SBCL`
    `brew install rlwrap`

* [Install *QuickLisp*](https://www.quicklisp.org/beta/#installation). 

* Start the *SBCL* REPL.
    `rlwrap sbcl`

* Load *cl-marklogic*.
    `(ql:quickload "cl-marklogic")`
    The first time you load *cl-marklogic*, *QuickLisp* will download it and the dependencies from the repository.

* Load and run the unit tests, *ml-test*.
    `(ql:quickload "ml-test")`
    `(ml-test:test-all)`
    The connect test will fail since we have not configured a *MarkLogic Server* connection. 

* Load and run *ml-optimizer*.
  `(ql:quickload "ml-optimizer")`
  `(ml-optimizer:start)`
  Connect to [*ml-optimizer*](http://localhost:9001) with a browser. By default *ml-optimizer* starts with a cached cluster configuration for demonstration.



