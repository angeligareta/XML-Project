#!/bin/bash

# Saxon 9 XSLT processor => 3.0
java -jar lib/saxon9he.jar -a:on -s:src/xml/recipe-book.xml -o:docs/index.html
mv src/*.html docs/
