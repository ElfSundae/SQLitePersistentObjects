//
//  RootViewController.m
//  SPOSample
//
//  Created by Elf Sundae on 13-5-7.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL hasMore;
@end

@implementation RootViewController

- (id)init
{
        self = [self initWithStyle:UITableViewStylePlain];
        srand((unsigned int)time(0));
        return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
        self = [super initWithStyle:style];
        if (self) {
                self.list = [[NSMutableArray alloc] init];
        }
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.navigationItem.title = @"SPOSample";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct)];
        if ([self.navigationItem respondsToSelector:@selector(setRightBarButtonItems:)]) {
                [self.navigationItem setRightBarButtonItems:@[
                 self.editButtonItem,
                 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(navRefreshItemPressed:)]
                 ]];
        } else {
                self.navigationItem.rightBarButtonItem = self.editButtonItem;
        }
        
        [self loadPagingData:NO];
}

- (void)navRefreshItemPressed:(id)sender
{
        [self loadPagingData:NO];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Data access

- (void)addProduct
{
        __block __es_weak __typeof__(self) _self = self;
        [UIAlertView alertViewWithTitle:@"Add a product"
                                message:nil
                      cancelButtonTitle:@"Cancel"
                     customizationBlock:^(UIAlertView *alertView) {
                             alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                             [alertView textFieldAtIndex:0].placeholder = @"ID";
                             [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
                             [alertView textFieldAtIndex:1].placeholder = @"Name";
                             [alertView textFieldAtIndex:1].secureTextEntry = NO;
                     } dismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                             if (buttonIndex != [alertView cancelButtonIndex]) {
                                     NSString *pid = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                     NSString *name = [[alertView textFieldAtIndex:1].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                     double price = 1.9 + (double)rand() / ((double)RAND_MAX/(999.99 - 1.9));
                                     __block void (^saveAndRefresh)(void) = ^() {
                                             Product *p = [Product productWithID:pid ifCreateNew:YES];
                                             p.name = name;
                                             p.price = price;
                                             p.isNewlyAdded = YES;
                                             p.addDate = [[NSDate date] timeIntervalSince1970];
                                             [p saveToDatabase];
                                             
                                             if (_self) {
                                                     [_self refresh];
                                             }
                                     };
                                     if (!pid.length || !name.length) {
                                             [UIAlertView alertViewWithTitle:@"Error" message:@"You must fill in ID and Name." cancelButtonTitle:@"OK" customizationBlock:nil dismissBlock:nil cancelBlock:nil otherButtonTitles:nil, nil];
                                     } else {
                                             if ([Product existsByID:pid]) {
                                                     [UIActionSheet actionSheetWithTitle:@"update exists product ?"
                                                                       cancelButtonTitle:@"Cancel"
                                                                      customizationBlock:nil
                                                                            dismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                                                              if (buttonIndex != [actionSheet cancelButtonIndex]) {
                                                                                      saveAndRefresh();
                                                                              }
                                                                      } cancelBlock:nil
                                                                              showInView:self.view
                                                                       otherButtonTitles:@"Update!", nil];
                                             } else {
                                                     saveAndRefresh();
                                             }
                                     }
                             }
                             
                     } cancelBlock:nil otherButtonTitles:@"Add", nil];
}

static NSUInteger _paging = 10;
- (void)refresh
{
        [self.list removeAllObjects];
        NSArray *allProducts = [Product allProducts];
        if (allProducts && allProducts.count) {
                [self.list addObjectsFromArray:allProducts];
                self.hasMore = (_paging == allProducts.count);
        } else {
                self.hasMore = NO;
        }
        [self.tableView reloadData];
}

- (void)loadPagingData:(BOOL)isMore
{
        if (!isMore) {
                [self.list removeAllObjects];
        }
        NSUInteger start = self.list.count;
        NSArray *products = [Product getListFrom:start countPerPage:_paging];
        if (products && [products count]) {
                [self.list addObjectsFromArray:products];
                self.hasMore = (products.count == _paging);
        } else {
                self.hasMore = NO;
        }
        
        [self.tableView reloadData];
        
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (0 == indexPath.section) {
                return self.tableView.rowHeight;
        } else {
                return self.hasMore ? self.tableView.rowHeight : 0.0;
        }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return (section ? 1 : self.list.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) {
                static NSString *cellID = @"CellID";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (nil == cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 200, 0, 200, cell.contentView.frame.size.height)];
                        lable.backgroundColor = [UIColor clearColor];
                        lable.tag = 100;
                        lable.textAlignment = UITextAlignmentRight;
                        lable.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                        [cell.contentView addSubview:lable];
                }
                Product *p = [self.list objectAtIndex:indexPath.row];
                cell.textLabel.text = p.name;
                cell.textLabel.textColor = (p.isNewlyAdded ? [UIColor redColor]: [UIColor blackColor]);
                [(UILabel *)[cell.contentView viewWithTag:100] setText:p.productId];
                [(UILabel *)[cell.contentView viewWithTag:100] setTextColor:(p.isNewlyAdded ? [UIColor redColor] : [UIColor blackColor])];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: $%.2f", p.price];
                return cell;
        } else {
                static NSString *moreCellID = @"MoreCellID";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreCellID];
                if (nil == cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellID];
                        cell.textLabel.textAlignment = UITextAlignmentCenter;
                        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
                        cell.textLabel.textColor = [UIColor blueColor];
                        cell.textLabel.text = @"Load More...";
                        cell.contentView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:0.8];
                        cell.textLabel.backgroundColor = [UIColor clearColor];
                }
                return cell;
        }
        
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        return (0 == indexPath.section);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (0 == indexPath.section && UITableViewCellEditingStyleDelete == editingStyle) {
                Product *p = [self.list objectAtIndex:indexPath.row];
                [self.list removeObject:p];
                [p deleteObject];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                [self.tableView endUpdates];
        }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (0 == indexPath.section) {
                Product *p = [self.list objectAtIndex:indexPath.row];
                [UIAlertView alertViewWithTitle:@"Product info" message:[p description] cancelButtonTitle:@"OK" customizationBlock:nil dismissBlock:nil cancelBlock:nil otherButtonTitles:nil, nil];
        } else if (1 == indexPath.section) {
                [self loadPagingData:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
}

@end
