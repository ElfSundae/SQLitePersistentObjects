//
//  SQLitePersistentObjects_MultiThreadTest.m
//  SQLitePersistentObjects_MultiThreadTest
//
//  Created by Gabriel Ayuso on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLitePersistentObjects_MultiThreadTest.h"
#import "SQLiteInstanceManager.h"
#import "DummyPersistentObject.h"

@implementation SQLitePersistentObjects_MultiThreadTest

NSString* const kTestDatabase = @"testDatabase.db";

- (void)setUp
{
    [super setUp];
	unlink([[[SQLiteInstanceManager sharedManager] databaseFilepath] cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)tearDown
{
    unlink([[[SQLiteInstanceManager sharedManager] databaseFilepath] cStringUsingEncoding:NSUTF8StringEncoding]);
    
    [super tearDown];
}

- (void)ignore_test_savingMultipleObjectsFromMultipleThreads_ShouldSaveAllSuccessfully
{
	int numIterations = 100;
	
	dispatch_queue_t queue = dispatch_queue_create("test_savingMultipleObjectsFromMultipleThreads_ShouldSaveAllSuccessfully", 0);
	
	for( int i = 0; i < numIterations; i++ )
	{
		dispatch_async(queue, 
		^{
			DummyPersistentObject* dummyObject = [[DummyPersistentObject alloc] init];
			
			dummyObject.name 	= [NSString stringWithFormat:@"Dummy %d", i];
			dummyObject.type 	= @"PersistentObject";
			dummyObject.date 	= [NSDate date];
			dummyObject.value 	= i;
			
			[dummyObject save];
			
			[dummyObject release];
		});
	}
	
	dispatch_barrier_sync(queue, 
	^{
		STAssertEquals(numIterations, (int)[DummyPersistentObject count], @"Should have stored all dummy objects");
	});
}

- (void)ignore_test_savingAndDeletingObjectsFromMultipleThreads_ShouldSaveAndDeleteAllSuccessfully
{
	int numIterations = 100;
	
	dispatch_queue_t queue = dispatch_queue_create("test_savingMultipleObjectsFromMultipleThreads_ShouldSaveAllSuccessfully", 0);
	
	for( int i = 0; i < numIterations; i++ )
	{
		DummyPersistentObject* dummyObject = [[[DummyPersistentObject alloc] init] autorelease];	
		dummyObject.name 	= [NSString stringWithFormat:@"Dummy %d", i];
		dummyObject.type 	= @"PersistentObject";
		dummyObject.date 	= [NSDate date];
		dummyObject.value 	= i;
		
		dispatch_async(queue, 
	    ^{		   
		   	[dummyObject save];
			STAssertEquals(1, (int)[DummyPersistentObject count], @"Should be empty");
	    });
		
		dispatch_async(queue, 
	    ^{		   
		   [dummyObject deleteObject];
	    });
		dispatch_async(queue, 
	    ^{
			
		   STAssertEquals(0, (int)[DummyPersistentObject count], @"Should be empty");
	    });
	}
	
	dispatch_barrier_sync(queue, 
	^{
		STAssertEquals(0, (int)[DummyPersistentObject count], @"Should have stored all dummy objects");
	});	
}

- (void)test_savingMultipleObjectsAndQueryingFromMultipleThreads_ShouldSaveAndQuerySuccessfully
{
	int numIterations = 100;
	
	dispatch_queue_t queue = dispatch_queue_create("test_savingMultipleObjectsFromMultipleThreads_ShouldSaveAllSuccessfully", 0);
	
	for( int i = 0; i < numIterations; i++ )
	{
		DummyPersistentObject* dummyObject = [[[DummyPersistentObject alloc] init] autorelease];
		
		dummyObject.name 	= [NSString stringWithFormat:@"Dummy %d", i];
		dummyObject.type 	= @"PersistentObject";
		dummyObject.date 	= [NSDate date];
		dummyObject.value 	= i;
		
		dispatch_async(queue, 
	    ^{
			[dummyObject save];
	    });
		
		dispatch_async(queue, 
	    ^{
			DummyPersistentObject* found = (DummyPersistentObject*)[DummyPersistentObject findFirstByCriteria:@"WHERE name = '%@'", dummyObject.name];
			STAssertEquals(dummyObject, found, @"Should be equal");
	    });
	}
	
	for( int i = 0; i < numIterations; i++ )
	{
		dispatch_async(queue, 
	    ^{
		   DummyPersistentObject* found = (DummyPersistentObject*)[DummyPersistentObject findFirstByCriteria:@"WHERE name = '%@'", [NSString stringWithFormat:@"Dummy %d", i]];
		   STAssertEquals(i, found.value, @"Should be equal");
	    });
	}
	
	dispatch_barrier_sync(queue, 
    ^{
		STAssertEquals(numIterations, (int)[DummyPersistentObject count], @"Should have stored all dummy objects");
    });
}

@end
