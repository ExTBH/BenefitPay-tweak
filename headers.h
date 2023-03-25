#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject
- (void)applicationWillEnterForeground:(UIApplication*)sharedApplication;
@end

@interface BPTransactionHistoryDetailCell : UIView <UIContextMenuInteractionDelegate>
@property (nonatomic, weak, readwrite) UILabel *lblDescription;
- (void)setupCellWithTitle:(NSString*)title andDescription:(NSString*)desc;
@end

@interface BPInboxDetailViewController : UIViewController <UIContextMenuInteractionDelegate>
@property (nonatomic, weak, readwrite) UILabel *lblMessage;
@end

// Benefit Beta Related

@interface TransactionDetailViewCell : UITableViewCell
@property (weak, nonatomic) UILabel *valueLabel;
@end

@interface TransactionFawriAndFawriPlusSentListingViewModel : NSObject <UITableViewDelegate>

@end