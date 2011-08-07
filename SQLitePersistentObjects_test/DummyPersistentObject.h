//
//  DummyPersistentObject.h
//  SQLitePersistentObjects_test
//
//  Created by Gabriel Ayuso on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

@interface DummyPersistentObject : SQLitePersistentObject

@property (nonatomic, readwrite, copy) NSString* name;
@property (nonatomic, readwrite, copy) NSString* type;
@property (nonatomic, readwrite, copy) NSDate* date;
@property (nonatomic, readwrite, assign) int value;

@end
