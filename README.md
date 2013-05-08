Introduction
======================

Persistent Objects for Cocoa & Cocoa Touch that using SQLite. <br>
This project based on http://code.google.com/p/sqlitepersistentobjects and https://bitbucket.org/gabrielayuso/sqlitepersistentobjects (make it thread safely)

Setup
=====================

1. Add `SQLitePersistentObjects` directory to your Xcode project. 
2. Link the `libsqlite3.dylib` framework.
3. If your project enabled ARC, set `-fno-objc-arc` flag to all SQLitePersistentObjects source files. <br>
**Step**: Open `Project Setting`, select target, go to `Build Phases`, shift-select all files `...in SQLitePersistentObjects`, then press Enter, fill in `-fno-objc-arc` in the popped textbox, then press Enter, it will be done.<br>
<a href="https://github.com/ElfSundae/SQLitePersistentObjects/raw/master/no-arc.jpg" target="_blank"><img src="https://github.com/ElfSundae/SQLitePersistentObjects/raw/master/no-arc.jpg" style="width:400px;height:260px;" /></a>

Usage
======================
**Overview:** http://code.google.com/p/sqlitepersistentobjects/source/browse/trunk/ReadMe.txt

1. Declare your data objects inherited from `SQLitePersistentObject`. Every property that's not a collection class (NSDictionary, NSArray, NSSet or mutable variants) will get persisted into a column in the database.
2. Name your properties in the **lower camel case** way. e.g. `productName` will be stored in datebase by named `product_name`.
3. Send `- (void)save;` method to save the data object to database.
4. Query:
```objc
        // get all Product objects from database
        NSArray *allObjects = [Product allObjects];
        // query with sql, sql starts with 'WHERE'
        Product *aProduct = (Product *)[Product findFirstByCriteria:@"WHERE pid = 100"];
        
        NSArray *someProducts = [Product findByCriteria:@"WHERE price > 20.0 LIMIT 0,30"]; 
```
5. Indexes: just override `+ (NSArray *)indices;` class method.
```objc
+ (NSArray *)indices
{
        return [NSArray arrayWithObjects:
                [NSArray arrayWithObjects:@"Id", nil],
                [NSArray arrayWithObjects:@"price", nil]
                , nil];
}
```
6. To filter properties that does not need to be saved to the database, just override `+ (NSArray *)transients;` class method.
```objc
+ (NSArray *)transients
{
        return [NSArray arrayWithObjects:@"isNewlyAdded", nil];
}
```
7. `- (void)deleteObject;`
8. `+ (void)clearCache;`

You may check out the file `SQLitePersistentObject.h` or the SPOSample project for more.