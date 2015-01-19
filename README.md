Functional Vilnius web
======================

[![Build Status](https://travis-ci.org/functional-vilnius/functional-vilnius.github.io.svg?branch=source)](https://travis-ci.org/functional-vilnius/functional-vilnius.github.io)

This repo holds the sources of [http://functionalvilnius.lt](http://functionalvilnius.lt).

The website is built using [Hakyll](http://jaspervdj.be/hakyll/).
It is automatically deployed after commits to the `source` branch are made.

How it works
------------

The setup is a combination of
[this](https://begriffs.com/posts/2014-08-12-create-static-site-with-hakyll-github.html)
and
[this](http://timbaumann.info/posts/2013-08-04-hakyll-github-and-travis.html).

The default branch is `source` (not `master`!), which contains the website
source.
When you push to `source`, a
[Travis CI](https://travis-ci.org/functional-vilnius/functional-vilnius.github.io/builds)
hook builds the website using Hakyll
and pushes the artifacts to the
[master](https://github.com/functional-vilnius/functional-vilnius.github.io/tree/master)
branch. See the [.travis.yml](.travis.yml) config file for details.


Developing locally
------------------

To develop locally, first clone the repo and install the dependencies (i.e. Hakyll)

    git clone https://github.com/functional-vilnius/functional-vilnius.github.io fv-web
    cd fv-web
    cabal sandbox init
    cabal install

After you edit the website, just run

    make

The generated web site will be in the folder `_site/`.
You can also tell Hakyll to watch for edits live and serve the website by running

    cabal run watch
