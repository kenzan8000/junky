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


@end
