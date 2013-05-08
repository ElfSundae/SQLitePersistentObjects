//
//  Product.h
//  SPOSample
//
//  Created by Elf Sundae on 13-5-7.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

@interface Product : SQLitePersistentObject
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double addDate;

@property (nonatomic, assign) BOOL isNewlyAdded;

+ (Product *)productWithID:(NSString *)pid ifCreateNew:(BOOL)create;
+ (BOOL)existsByID:(NSString *)productID;
+ (NSArray *)allProducts;
- (void)saveToDatabase;
+ (NSArray *)getListFrom:(NSUInteger)start countPerPage:(NSUInteger)paging;
@end
