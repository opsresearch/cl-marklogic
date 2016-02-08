# *cl-marklogic*
*cl-marklogic* is a *Common Lisp* system for working with *MarkLogic* clusters. There is a stable version of *cl-marklogic* in the *QuickLisp* repository.

*ml-optimizer* [Demonstration](http://opsresearch.com/demo/ml-optimizer/).

Tested with *MarkLogic* 8.
Tested with *SBCL* and *ABCL*.

# Quick Start

This quick tutorial shows you how to run some simple examples using *cl-marklogic*. It is written to use *SBCL*, and *QuickLisp* on *OSX*. If you are using a different operating system you will need to adjust some details but the overall steps will be the same.

#### 1. [Install *Homebrew*](http://brew.sh).

#### 2. Install *SBCL*:
  ```
  brew update
  brew install SBCL
  brew install rlwrap
  ```

#### 3. [Install *QuickLisp*](https://www.quicklisp.org/beta/#installation). 

#### 4. Start the *SBCL* REPL:
  ```
  rlwrap sbcl
  ```

#### 5. Load *cl-marklogic*.
  ```
  (ql:quickload "cl-marklogic")
  ```
   >The first time you load *cl-marklogic*, *QuickLisp* will download it and any dependencies from the repository.

#### 6. Load *ml-test* and run the unit tests:
  ```
  (ql:quickload "ml-test")
  (ml-test:test-all)
  ```
  >The connect test will fail since we have not configured a *MarkLogic* connection. 

#### 7. Load *ml-optimizer* and start it:
  ```
  (ql:quickload "ml-optimizer")
  (ml-optimizer:start)
  ```

#### 8. Connect to [*ml-optimizer*](http://localhost:9001) with a browser.
  >By default *ml-optimizer* starts with a cached cluster configuration for demonstration.



