#!/bin/bash

# Procesador de Saxon 9 XSLT => 3.0
java -jar lib/saxon9he.jar -a:on -s:XML/recipe-book.xml -o:HTML/index.html