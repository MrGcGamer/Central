#include "CRLRootListController.h"
#import <spawn.h>

@implementation CRLRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring{
	if (@available(iOS 11, *)){
		pid_t pid;
    	const char* args[] = {"sbreload", NULL};
    	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
	} else {
		pid_t pid;
    	const char* args[] = {"killall", "backboardd", NULL};
    	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
	}
}

@end
