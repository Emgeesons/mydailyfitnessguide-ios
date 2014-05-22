
#import "MVPickerAlertView.h"

@interface MVPickerAlertView ()<UIPickerViewDataSource, UIPickerViewDelegate, MVCustomAlertViewClientDelegate>
@property(strong, nonatomic) UIPickerView *pickerView;
@property(strong, nonatomic) NSArray *values1, *values2, *values3;
@property (nonatomic) NSInteger val1, val2, val3;
@end

@implementation MVPickerAlertView

- (id)initWithTitle:(NSString *)title values1:(NSArray *)values1 values2:(NSArray *)values2 values3:(NSArray *)values3 delegate:(id)delegate {

    if ((self = [super initWithDelegate:delegate])) {

        self.title = title;
        self.values1 = values1;
        self.values2 = values2;
        self.values3 = values3;
        self.pickerView = [UIPickerView new];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        self.pickerView.showsSelectionIndicator = YES;
    }
    return self;
}

- (UIView *)contentView
{
    [self cancelButtonTitle:@"Dismiss" confirmButtonTitle:@"OK"];
    return self.pickerView;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.values1.count;
    } else if (component == 1) {
        return self.values2.count;
    } else {
        return self.values3.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.values1[row];
    } else if (component == 1) {
        return self.values2[row];
    } else {
        return self.values3[row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.val1 = [self.pickerView selectedRowInComponent:0];
    } else if (component == 1) {
        self.val2 = [self.pickerView selectedRowInComponent:1];
    } else {
        self.val3 = [self.pickerView selectedRowInComponent:2];
    }
}

#pragma mark - MVCustomAlertViewClientDelegate

- (void)customAlertViewDidCancel:(MVCustomAlertView *)alertView {
    
}
- (void)customAlertViewDidConfirm:(MVCustomAlertView *)alertView {
    
}

@end