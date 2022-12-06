#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <substrate.h>

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

static const HBPreferences *tweakPreferences; 

// nedded when hooking an app
@class HBForceCepheiPrefs;
static BOOL override_HBForeCepheiPrefs_forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear(id self, SEL _cmd){
    return YES;
}

static void (*orig_AppDelegate_applicationWillEnterForeground)(id, SEL, UIApplication*);
static void override_AppDelegate_applicationWillEnterForeground(id self, SEL _cmd, UIApplication *sharedApplication){
	BOOL isPreventLock;
	[tweakPreferences registerBool:&isPreventLock default:YES forKey:@"Lock"];
	if (!isPreventLock){
		orig_AppDelegate_applicationWillEnterForeground(self, _cmd, sharedApplication);
	}

}

static UIContextMenuConfiguration *new_BPTransactionHistoryDetailCell_contextMenuInteraction$configurationForMenuAtLocation(
    BPTransactionHistoryDetailCell *self,
    SEL _cmd,
    UIContextMenuInteraction *interaction,
    CGPoint location)
{
	UIAction *copy = [UIAction actionWithTitle:@"Copy"
        image:nil
        identifier:nil
        handler:^(UIAction *handler) {
            UIPasteboard.generalPasteboard.string = self.lblDescription.text;
            }];
    
    UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[copy]];

    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
        previewProvider:nil
        actionProvider:^(NSArray *suggestedActions) {
            return menu;
            }];
    
    return configuration;
}

static void (*orig_BPTransactionHistoryDetailCell_setupCellWithTitle$andDescription)(id, SEL, NSString*, NSString*);
static void override_BPTransactionHistoryDetailCell_setupCellWithTitle$andDescription(BPTransactionHistoryDetailCell *self, SEL _cmd, NSString* title, NSString*description){
    orig_BPTransactionHistoryDetailCell_setupCellWithTitle$andDescription(self, _cmd, title, description);

    BOOL isCopy;
	[tweakPreferences registerBool:&isCopy default:YES forKey:@"Copying"];
    
	if (isCopy){
        static dispatch_once_t onceToken;
        dispatch_once(
            &onceToken,
            ^{
                class_addMethod([self class], 
                @selector(contextMenuInteraction:configurationForMenuAtLocation:), 
                (IMP) &new_BPTransactionHistoryDetailCell_contextMenuInteraction$configurationForMenuAtLocation,
                "@@:{name=CGPoint}");
            }
        );

		UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
		self.userInteractionEnabled = YES;
		[self addInteraction:interaction];
	}
}


static UIContextMenuConfiguration *new_BPInboxDetailViewController_contextMenuInteraction$configurationForMenuAtLocation(
    BPInboxDetailViewController *self,
    SEL _cmd,
    UIContextMenuInteraction *interaction,
    CGPoint location)
{
	UIAction *copy = [UIAction actionWithTitle:@"Copy"
						image:nil identifier:nil handler:^(UIAction *handler) {
							UIPasteboard.generalPasteboard.string = self.lblMessage.text;
						}];

	UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[copy]];

	UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil
										actionProvider:^(NSArray *suggestedActions) { return menu;}];
	return configuration;
}


static void (*orig_BPInboxDetailViewController_viewDidLoad)(id, SEL);
static void override_BPInboxDetailViewController_viewDidLoad(BPInboxDetailViewController *self, SEL _cmd){
    orig_BPInboxDetailViewController_viewDidLoad(self, _cmd);
    BOOL isCopy;
	[tweakPreferences registerBool:&isCopy default:YES forKey:@"Copying"];
    
    if (isCopy){
        static dispatch_once_t onceToken;
        dispatch_once(
            &onceToken,
            ^{
                class_addMethod([self class], 
                @selector(contextMenuInteraction:configurationForMenuAtLocation:), 
                (IMP) &new_BPInboxDetailViewController_contextMenuInteraction$configurationForMenuAtLocation,
                "@@:{name=CGPoint}");
            }
        );
		UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
		self.lblMessage.userInteractionEnabled = YES;
		[self.lblMessage addInteraction:interaction];
	}
}





__attribute__((constructor)) static void init(){
    MSHookMessageEx(
        objc_getMetaClass("HBForceCepheiPrefs"), 
        @selector(forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear), 
        (IMP) &override_HBForeCepheiPrefs_forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear, 
        NULL);
    
    MSHookMessageEx(
        NSClassFromString(@"AppDelegate"), 
        @selector(applicationWillEnterForeground:), 
        (IMP) &override_AppDelegate_applicationWillEnterForeground, 
        (IMP*) &orig_AppDelegate_applicationWillEnterForeground);

    MSHookMessageEx(NSClassFromString(@"BPTransactionHistoryDetailCell"), 
        @selector(setupCellWithTitle:andDescription:), 
        (IMP) &override_BPTransactionHistoryDetailCell_setupCellWithTitle$andDescription, 
        (IMP*) &orig_BPTransactionHistoryDetailCell_setupCellWithTitle$andDescription);

    MSHookMessageEx(NSClassFromString(@"BPInboxDetailViewController"), 
        @selector(viewDidLoad), 
        (IMP) &override_BPInboxDetailViewController_viewDidLoad, 
        (IMP*) &orig_BPInboxDetailViewController_viewDidLoad);


    tweakPreferences = [[HBPreferences alloc] 
        initWithIdentifier:@"dev.extbh.benefitpay++.prefs"];
}