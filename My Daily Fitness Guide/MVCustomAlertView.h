

#import <Foundation/Foundation.h>

@class MVCustomAlertView;

@protocol MVCustomAlertViewClientDelegate<NSObject>
- (void)customAlertViewDidCancel:(MVCustomAlertView *)alertView;
@optional
- (void)customAlertViewDidConfirm:(MVCustomAlertView *)alertView;
// Subclasses can extend protocol for positive flows
@end

@protocol MVCustomAlertViewDelegate
- (UIView *)contentView;
- (BOOL)onConfirm;
@end

/*
 Reusable custom alert view class.
 Subclass to add contentView(s) (see MVPickerAlertView).
 */
@interface MVCustomAlertView : UIViewController<MVCustomAlertViewDelegate>

- (id)initWithDelegate:(id<MVCustomAlertViewClientDelegate>)delegate;

- (void) cancelButtonTitle:(NSString *)cancelTitle confirmButtonTitle:(NSString *)confirmButtonTitle;

@property (weak, readonly) id<MVCustomAlertViewClientDelegate> delegate;

@end