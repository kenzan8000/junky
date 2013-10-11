#!/bin/bash

python graphviz/objc_dep.py junkbox/Classes > graphviz/junkbox.dot
dot -Tpng graphviz/junkbox.dot > graphviz/junkbox.png
