#import "SSGentleAlertView+Junkbox.h"
#import "SSDialogView.h"


#pragma mark - SSGentleAlertView+Junkbox
@implementation SSGentleAlertView (Junkbox)


#pragma mark - api
+ (void)showWithMessage:(NSString *)message
           buttonTitles:(NSArray *)buttonTitles
               delegate:(id)delegate
{
    SSGentleAlertView *alertView = [SSGentleAlertView alertViewWithMessage:message
                                                              buttonTitles:buttonTitles
                                                                  delegate:delegate];
    [alertView show];
}


#pragma mark - private api
+ (SSGentleAlertView *)alertViewWithMessage:(NSString *)message
                               buttonTitles:(NSArray *)buttonTitles
                                   delegate:(id)delegate
{
    SSGentleAlertView *alertView = [SSGentleAlertView new];
    alertView.message = message;
    for (id title in buttonTitles) {
        [alertView addButtonWithTitle:[NSString stringWithFormat:@"%@", title]];
    }
    alertView.delegate = delegate;
    if (buttonTitles.count <= 1) {
        alertView.disappearWhenBackgroundClicked = YES;
    }
    return alertView;
}
/*
    alertView.titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    alertView.titleLabel.shadowColor = UIColor.clearColor;
    alertView.messageLabel.textColor = [UIColor colorWithRed:0.4 green:0.2 blue:0.0 alpha:1.0];
    alertView.messageLabel.shadowColor = UIColor.clearColor;

    UIButton* button = [alert buttonBase];
    [button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_normal"]] forState:UIControlStateNormal];
    [button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_pressed"]] forState:UIControlStateHighlighted];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [alert setButtonBase:button];
    [alert setDefaultButtonBase:button];
*/


@end
