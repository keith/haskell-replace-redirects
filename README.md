Replace Redirects Exercise
==========================

In this exercise, you'll write a script to replace URLs which redirect with
their canonical results.

Write your solution in main.hs:

    vim main.hs

We've included a sample input file which contains numerous URLs, as well as the
expected output for that file. You can run your solution and compare your output
with the expected output:

    ./test

If all is well, you'll see "PASSED." If the output doesn't match, you'll see a
diff describing what went wrong.

## External Libraries

You may want to use some external libraries in your solution. If you've
installed the Haskell platform, you can use cabal. For example:

    cabal install regex-pcre

## Documentation

If you're new to Haskell, you might not know how to find documentation for the
libraries you're using. Check these out:

* [Hoogle] contains documentation for everything in the GHC standard libraries.
  You can search for a function name or even a type signature.
* [Hayoo] searches for documentation within Hackage. You can search for function
  names, library names, or strings within documentation.

[Hoogle]: http://www.haskell.org/hoogle/
[Hayoo]: http://holumbus.fh-wedel.de/hayoo/hayoo.html

## Working/Submitting

Run `git push origin master` and submit your solution on Whetstone once you're
finished.
