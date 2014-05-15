//
//  Product.m
//  SPOSample
//
//  Created by Elf Sundae on 13-5-7.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "Product.h"

@implementation Product

+ (NSString *)tableName
{
        return @"product";
}

+ (NSArray *)indices
{
        return @[@[@"productId"],
                @[@"addDate"],
                @[@"price", @"addDate"]];
}

+ (NSArray *)transients
{
        return @[@"isNewlyAdded"];
}

- (NSString *)description
{
        static NSDateFormatter *_formatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                _formatter = [[NSDateFormatter alloc] init];
                [_formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        });
        NSString *date = [_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.addDate]];
        return [NSString stringWithFormat:@"ID: %@\nName: %@\nPrice: $%.2f\naddDate: %@",
                self.productId, self.name, self.price, date];
}

#pragma mark - 
+ (Product *)productWithID:(NSString *)pid ifCreateNew:(BOOL)create
{
        Product *p = (Product *)[self findFirstByCriteria:@"WHERE product_id = %@", pid];
        if (!p && create) {
                p = [[self alloc] init];
                p.productId = pid;
        }
        return p;
}

+ (BOOL)existsByID:(NSString *)productID
{
        Product *p = (Product *)[self findFirstByCriteria:@"WHERE product_id = %@", productID];
        return !!p;
}

+ (NSArray *)allProducts
{
        return [self allObjects];
}

+ (NSArray *)allObjects
{
        return [self findByCriteria:@"ORDER BY add_date desc"];
}

- (void)saveToDatabase
{
        Product *p = [[self class] productWithID:self.productId ifCreateNew:NO];
        if (p) {
                p.name = self.name;
                p.price = self.price;
                p.addDate = self.addDate;
                p.isNewlyAdded = self.isNewlyAdded;
                [p save];
        } else {
                [self save];
        }
}

+ (NSArray *)getListFrom:(NSUInteger)start countPerPage:(NSUInteger)paging
{
        return [[self class] findByCriteria:@"ORDER BY add_date desc LIMIT %d,%d", start, paging];
}
@end
