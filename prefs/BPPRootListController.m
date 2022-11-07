#import <Foundation/Foundation.h>
#include <Foundation/NSURL.h>
#import "BPPRootListController.h"

@implementation BPPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)openGithub {
	NSURL *url = [NSURL URLWithString:@"https://github.com/ExTBH/BenefitPay-tweak"];
	if([UIApplication.sharedApplication canOpenURL:url]){
		[UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];}
}
- (void)openTwitter {
	NSURL *url = [NSURL URLWithString:@"https://twitter.com/@ExTBH"];
	if([UIApplication.sharedApplication canOpenURL:url]){
		[UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];}
}

@end

