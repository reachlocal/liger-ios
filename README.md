# Liger iOS [![Build Status](https://api.travis-ci.org/reachlocal/liger-ios.png)](https://travis-ci.org/reachlocal/liger-ios)

For more information about developing apps with Liger Mobile go to the main [Liger Mobile repo](https://github.com/reachlocal/liger).

Liger-iOS is the iOS specific component to Liger. It's the part that creates and opens pages and dialogs and is the gateway into using native pages, both custom written for Liger, Apple's own, and from 3rd parties.

Liger-iOS is intended to be used as a [cocoapod](http://www.cocoapods.org) in an application. There's a number of XCTest test cases written and we use [Travis CI](https://travis-ci.org/reachlocal/liger-ios) to continuously build and run those tests.

To run the tests and generate coverage files, run this at the command line using the latest version of xctool/Xcode:

```bash
xctool build test -destination 'OS=7.1,name=iPhone Retina (4-inch 64-bit)' GCC_GENERATE_TEST_COVERAGE_FILES=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES
```