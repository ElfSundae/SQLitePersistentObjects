//
//  DummyPersistentObject.m
//  SQLitePersistentObjects_test
//
//  Created by Gabriel Ayuso on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DummyPersistentObject.h"

@implementation DummyPersistentObject
@synthesize name;
@synthesize type;
@synthesize date;
@synthesize value;


- (id)init
{
    self = [super init];
    if (self) 
	{
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc 
{
    self.name = nil;
    self.type = nil;
    [super dealloc];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"<DummyPersistentObject.%d> {name: %@, type: %d, date: %@}", self.pk, self.name, self.type, self.date];
}

@end
