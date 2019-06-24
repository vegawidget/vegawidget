## vegawidget 0.2.1

Pursuant to Uwe's emails at release of 0.1.0 (January 2019):

* In DESCRIPTION, I have enclosed software names in single-quotes.

* Most of the examples are run; the examples that \dontrun{} show specialized 
  capabilities. There are three reasons for not running examples:

  - requires nodejs to be installed
  - requires network-access
  - intentionally invokes error-behavior (I have unexported this internal function)
  
  At the the top of each \dontrun{} block, I have noted the specific reason.

-----------------

## Test environments
* local OS X install, R 3.5.3
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit
* Ubuntu Linux 16.04 LTS, R-release, GCC
* Fedora Linux, R-devel, clang, gfortran
* ubuntu 14.04 (on travis-ci), R (oldrel, release, and devel)
* win-builder (release)

## R CMD check results

0 errors | 0 warnings | 0 notes


  



  
