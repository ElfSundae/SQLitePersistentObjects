Introduction
======================

Persistent Objects for Cocoa & Cocoa Touch that using SQLite. <br>
This project based on http://code.google.com/p/sqlitepersistentobjects and https://bitbucket.org/gabrielayuso/sqlitepersistentobjects (make it thread safely) <br>
Overview: http://code.google.com/p/sqlitepersistentobjects/source/browse/trunk/ReadMe.txt

Setup
=====================

1. Add `SQLitePersistentObjects` directory to your Xcode project. 
2. Link the `libsqlite3.dylib` framework.
3. If your project enabled ARC, set `-fno-objc-arc` flag to all SQLitePersistentObjects source files. <br>
Step: Open `Project Setting`, select target, go to `Build Phases`, shift-select all files `...in SQLitePersistentObjects`, then press Enter, fill in `-fno-objc-arc` in the popped textbox, then press Enter, it will be done.<br>
![no-arc](https://github.com/ElfSundae/SQLitePersistentObjects/raw/master/no-arc.jpg "no-arc")

Usage
======================