#import <Foundation/Foundation.h>
#import "BPPRootListController.h"

@implementation BPPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}
@end

