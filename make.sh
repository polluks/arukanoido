#!/bin/sh

cd sound-beamrider; ./make.sh ; cd ..
sbcl --noinform --core bender/bender make.lisp
