## Test environments
* local OS X install, R 3.5.2
* local Windows install, R 3.5.2
* ubuntu 14.04 (on travis-ci), R (oldrel, release, and devel)
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

Maintainer: 'Ian Lyttle <ian.lyttle@schneider-electric.com>'

New submission

Possibly mis-spelled words in DESCRIPTION:
  Htmlwidget (3:8)
  JSON (4:47)
  Renderer (3:19)
  
* This is a new submission
  
* I believe the first note to be normal; as for the possibly mis-spelled 
  words in DESCRIPTION:
  
  - "Htmlwidget" and "JSON" are current terms-of-art.
  - "Renderer" is unusual, but correct.
  
-----------------

## Resubmission 2019-01-20

Pursuant to Uwe's email of 2019-01-19:

* I have changed the examples to write to tempdir(); my apologies, 
  I should have known better.

* Most of the examples are run; the examples that \dontrun{} show specialized 
  capabilities. There are three reasons for not running examples:

  - requires nodejs to be installed
  - requires network-access
  - intentionally invokes error-behavior (I have unexported this internal function)
  
  At the the top of each \dontrun{} block, I have noted the specific reason.
  
