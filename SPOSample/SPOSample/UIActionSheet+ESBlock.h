//
//  UIActionSheet+Block.h
//  niupai
//
//  Created by Elf Sundae on 12-11-17.
//
//

#import <UIKit/UIKit.h>

typedef void (^ESActionSheetCancelBlock)();
typedef void (^ESActionSheetDismissBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex);
typedef void (^ESActionSheetCustomizationBlock)(UIActionSheet *actionSheet);

@interface UIActionSheet (ESBlock) <UIActionSheetDelegate>
@property (nonatomic, copy) ESActionSheetCancelBlock cancelBlock;
@property (nonatomic, copy) ESActionSheetCustomizationBlock customizationBlock;
@property (nonatomic, copy) ESActionSheetDismissBlock dismissBlock;

+ (void)actionSheetWithTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle_
          customizationBlock:(ESActionSheetCustomizationBlock)customizationBlock_
                dismissBlock:(ESActionSheetDismissBlock)dismissBlock_
                 cancelBlock:(ESActionSheetCancelBlock)cancelBlock_
                  showInView:(UIView *)view
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end
