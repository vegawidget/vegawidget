## vegawidget 0.3.1

On win-builder (release), I get a note:

```
Found the following (possibly) invalid URLs:
  URL: https://ijlyttle.shinyapps.io/vegawidget-overview
    From: inst/doc/vegawidget.html
    Status: Error
    Message: libcurl error code 35:
      	Unknown SSL protocol error in connection to ijlyttle.shinyapps.io:443
```

I have checked the URL - it is valid, so I suspect some sort of network difficulty at win-builder.

## Test environments

* local OS X install, R 3.6.2
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit
* Ubuntu Linux 16.04 LTS, R-release, GCC
* Fedora Linux, R-devel, clang, gfortran
* ubuntu 16.04 (on travis-ci), R (oldrel, release, and devel)
* win-builder (release)

## R CMD check results

0 errors | 0 warnings | 0 notes


  



  
