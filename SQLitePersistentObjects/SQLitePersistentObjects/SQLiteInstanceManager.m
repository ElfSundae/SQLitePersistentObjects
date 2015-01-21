//
//  SQLiteInstanceManager.m
// ----------------------------------------------------------------------
// Part of the SQLite Persistent Objects for Cocoa and Cocoa Touch
//
// Original Version: (c) 2008 Jeff LaMarche (jeff_Lamarche@mac.com)
// ----------------------------------------------------------------------
// This code may be used without restriction in any software, commercial,
// free, or otherwise. There are no attribution requirements, and no
// requirement that you distribute your changes, although bugfixes and 
// enhancements are welcome.
// 
// If you do choose to re-distribute the source code, you must retain the
// copyright notice and this license information. I also request that you
// place comments in to identify your changes.
//
// For information on how to use these classes, take a look at the 
// included Readme.txt file
// ----------------------------------------------------------------------


#import "SQLiteInstanceManager.h"
#import "SQLitePersistentObject.h"

static SQLiteInstanceManager *sharedSQLiteManager = nil;

#pragma mark Private Method Declarations
@interface SQLiteInstanceManager (private)
- (NSString *)databaseFilepath;
@end

@implementation SQLiteInstanceManager

@synthesize databaseFilepath;

#pragma mark -
#pragma mark Singleton Methods
+ (id)sharedManager 
{
	@synchronized(self) 
	{
		if (sharedSQLiteManager == nil) 
			sharedSQLiteManager = [[self alloc] init]; 
	}
	return sharedSQLiteManager;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (sharedSQLiteManager == nil) 
		{
			sharedSQLiteManager = [super allocWithZone:zone];
			return sharedSQLiteManager; 
		}
	}
	return nil;
}
- (id)copyWithZone:(NSZone *)zone
{
	return self;
}
//- (id)retain
//{
//	return self;
//}
//- (NSUInteger)retainCount
//{
//	return UINT_MAX;  //denotes an object that cannot be released
//}
//- (oneway void)release
//{
//	// never release
//}
//- (id)autorelease
//{
//	return self;
//}
#pragma mark -
#pragma mark Public Instance Methods
-(sqlite3 *)database
{
	static BOOL first = YES;
	
	if (first || database == NULL)
	{
		first = NO;
		if (!sqlite3_open([[self databaseFilepath] UTF8String], &database) == SQLITE_OK) 
		{
			// Even though the open failed, call close to properly clean up resources.
			NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
			sqlite3_close(database);
		}
		else
		{
			// Default to UTF-8 encoding
			[self executeUpdateSQL:@"PRAGMA encoding = \"UTF-8\""];
			
			// Turn on full auto-vacuuming to keep the size of the database down
			// This setting can be changed per database using the setAutoVacuum instance method
			[self executeUpdateSQL:@"PRAGMA auto_vacuum=1"];
            
            // Set cache size to zero. This will prevent performance slowdowns as the
            // database gets larger
            [self executeUpdateSQL:@"PRAGMA CACHE_SIZE=0"];
			
		}
	}
	return database;
}
- (BOOL)tableExists:(NSString *)tableName
{
	BOOL ret = NO;
	// pragma table_info(i_c_project);
	NSString *query = [NSString stringWithFormat:@"pragma table_info(%@);", tableName];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database,  [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		if (sqlite3_step(stmt) == SQLITE_ROW)
			ret = YES;
		sqlite3_finalize(stmt);
	}
	return ret;
}
- (void)setAutoVacuum:(SQLITE3AutoVacuum)mode
{
	NSString *updateSQL = [NSString stringWithFormat:@"PRAGMA auto_vacuum=%d", mode];
	[self executeUpdateSQL:updateSQL];
}
- (void)setCacheSize:(NSUInteger)pages
{
	NSString *updateSQL = [NSString stringWithFormat:@"PRAGMA cache_size=%lu", (unsigned long)pages];
	[self executeUpdateSQL:updateSQL];
}
- (void)setLockingMode:(SQLITE3LockingMode)mode
{
	NSString *updateSQL = [NSString stringWithFormat:@"PRAGMA locking_mode=%d", mode];
	[self executeUpdateSQL:updateSQL];
}
- (void)deleteDatabase
{
        [self close];
	NSString* path = [self databaseFilepath];
	NSFileManager* fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:path error:NULL];
	[SQLitePersistentObject clearCache];
}
- (void)vacuum
{
	[self executeUpdateSQL:@"VACUUM"];
}
- (void)executeUpdateSQL:(NSString *) updateSQL
{
	char *errorMsg;
	if (sqlite3_exec([self database],[updateSQL UTF8String] , NULL, NULL, &errorMsg) != SQLITE_OK) {
		NSString *errorMessage = [NSString stringWithFormat:@"Failed to execute SQL '%@' with message '%s'.", updateSQL, errorMsg];
#pragma unused(errorMessage)		
		NSAssert(0, errorMessage);
		sqlite3_free(errorMsg);
	}
}
#pragma mark -
//- (void)dealloc
//{
//	[databaseFilepath release];
//	[super dealloc];
//}

- (void)close
{
        if (database) {
		sqlite3_close(database);
		database = NULL;
	}
}

+ (void)reset
{
        @synchronized(self) {
		if (nil != sharedSQLiteManager) {
			[sharedSQLiteManager close];
                        [SQLitePersistentObject clearCache];
                        sharedSQLiteManager = nil;
		}
	}
        
        [self sharedManager];
}

#pragma mark -
#pragma mark Private Methods

- (NSString *)databaseFilepath
{
	if (databaseFilepath == nil)
	{
		NSMutableString *ret = [NSMutableString string];
		NSString *appName = [[NSProcessInfo processInfo] processName];
		for (int i = 0; i < [appName length]; i++)
		{
			NSRange range = NSMakeRange(i, 1);
			NSString *oneChar = [appName substringWithRange:range];
			if (![oneChar isEqualToString:@" "]) 
				[ret appendString:[oneChar lowercaseString]];
		}
#if (TARGET_OS_COCOTRON)
		NSString *saveDirectory = @"./"; // TODO: default path is undefined on coctron
#elif (TARGET_OS_MAC && ! TARGET_OS_IPHONE)
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
		NSString *saveDirectory = [basePath stringByAppendingPathComponent:appName];
#else
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString *saveDirectory = paths[0];
#endif
		NSString *saveFileName = [NSString stringWithFormat:@"%@.db", ret];
		NSString *filepath = [saveDirectory stringByAppendingPathComponent:saveFileName];
		
		databaseFilepath = filepath;
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:saveDirectory]) 
			[[NSFileManager defaultManager] createDirectoryAtPath:saveDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return databaseFilepath;
}

- (void)setDatabaseFilepath:(NSString *)path
{
        if (path) {
                NSString *dir = [path stringByDeletingLastPathComponent];
                if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
                        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
                }
        }
        databaseFilepath = path;
}
@end
