#import <UIKit/UIKit.h>


// MARK: - Transaction History Related
@interface BPTransactionHistoryDetailCell : UIView <UIContextMenuInteractionDelegate>
@property (nonatomic, weak, readwrite) UILabel *lblDescription;
- (void)setupCellWithTitle:(id)title andDescription:(id)desc;
@end

%hook BPTransactionHistoryDetailCell
- (void)setupCellWithTitle:(id)title andDescription:(id)desc{
	%orig;
	UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
	self.userInteractionEnabled = YES;
	[self addInteraction:interaction];
}

// MARK: - Start of Copying
%new
- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location{

	UIAction *copy = [UIAction actionWithTitle:@"Copy"
						image:nil identifier:nil handler:^(UIAction *handler) {
							UIPasteboard.generalPasteboard.string = self.lblDescription.text;
						}];

	UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[copy]];

	UIContextMenuConfiguration *conf = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil
										actionProvider:^(NSArray *suggestedActions) { return menu;}];
	return conf;
}
%end



// MARK: - Inbox Related
@interface BPInboxDetailViewController : UIViewController <UIContextMenuInteractionDelegate>
@property (nonatomic, weak, readwrite) UILabel *lblMessage;
@end

%hook BPInboxDetailViewController
- (void)viewDidLoad{
	%orig;
	UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
	self.lblMessage.userInteractionEnabled = YES;
	[self.lblMessage addInteraction:interaction];
}

// MARK: - Start of Copying
%new
- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location{

	UIAction *copy = [UIAction actionWithTitle:@"Copy"
						image:nil identifier:nil handler:^(UIAction *handler) {
							UIPasteboard.generalPasteboard.string = self.lblMessage.text;
						}];

	UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[copy]];

	UIContextMenuConfiguration *conf = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil
										actionProvider:^(NSArray *suggestedActions) { return menu;}];
	return conf;
}
%end
