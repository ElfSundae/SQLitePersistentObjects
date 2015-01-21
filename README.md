Introduction
======================

Persistent Objects for Cocoa & Cocoa Touch that using SQLite.

This project based on http://code.google.com/p/sqlitepersistentobjects and https://bitbucket.org/gabrielayuso/sqlitepersistentobjects (make it thread safely)

Setup
=====================

1. Add `SQLitePersistentObjects.framework` to your Xcode project
2. Link the `libsqlite3.dylib`
3. Add `-ObjC` to your project's settings `Other Linker Flags`
4. `#import <SQLitePersistentObjects/SQLitePersistentObjects.h>` and subclass `SQLitePersistentObject` for your data model


Usage
======================
**Overview:** http://code.google.com/p/sqlitepersistentobjects/source/browse/trunk/ReadMe.txt

1. Declare your data objects inherited from `SQLitePersistentObject`. Every property that's not a collection class (NSDictionary, NSArray, NSSet or mutable variants) will get persisted into a column in the database.
2. Name your properties in the **lower camel case** way. e.g. `productName` will be stored in datebase by named `product_name`.
3. Send `- (void)save;` method to save the data object to database.
4. Query:


		// get all Product objects from database
		NSArray *allObjects = [Product allObjects];
		// query with sql, sql starts with 'WHERE'
		Product *aProduct = (Product *)[Product findFirstByCriteria:@"WHERE pid = 100"];
		
		NSArray *someProducts = [Product findByCriteria:@"WHERE price > 20.0 LIMIT 0,30"]; 


5. Indexes: just override `+ (NSArray *)indices;` class method.

		+ (NSArray *)indices
		{
		        return [NSArray arrayWithObjects:
		                [NSArray arrayWithObjects:@"pID", nil],
		                [NSArray arrayWithObjects:@"price", nil]
		                , nil];
		}

6. To filter properties that does not need to be saved to the database, just override `+ (NSArray *)transients;` class method.

		+ (NSArray *)transients
		{
		        return [NSArray arrayWithObjects:@"isNewlyAdded", nil];
		}

7. `- (void)deleteObject;`
8. `+ (void)clearCache;`
9. `[SQLiteInstanceManager reset];`
10. `[[SQLiteInstanceManager sharedManager] setDatabaseFilepath:dbPath];`;

You may check out the file `SQLitePersistentObject.h` or the SPOSample project for more.