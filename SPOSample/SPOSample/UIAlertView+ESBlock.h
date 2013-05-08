//
//  UIAlertView+ESBlock.h
//  DouSearch
//
//  Created by Elf Sundae on 3/19/13.
//  Copyright (c) 2013 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ESAlertViewCancelBlock)();
typedef void (^ESAlertViewDismissBlock)(UIAlertView *alertView, NSInteger buttonIndex);
typedef void (^ESAlertViewCustomizationBlock)(UIAlertView *alertView);


@interface UIAlertView (ESBlock) <UIAlertViewDelegate>
@property (nonatomic, copy) ESAlertViewCancelBlock cancelBlock;
@property (nonatomic, copy) ESAlertViewCustomizationBlock customizationBlock;
@property (nonatomic, copy) ESAlertViewDismissBlock dismissBlock;

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle_
        customizationBlock:(ESAlertViewCustomizationBlock)customizationBlock
              dismissBlock:(ESAlertViewDismissBlock)dismissBlock
               cancelBlock:(ESAlertViewCancelBlock)cancelBlock
         otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
