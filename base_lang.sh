#!/bin/bash

home=`pwd`
path=$home/DigiDocs

fromDir=$path/en.lproj
toDir=$path/Base.lproj

cp "$fromDir"/*.strings "$toDir/"