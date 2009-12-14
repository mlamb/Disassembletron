#import "MyApplicationDelegate.h"
#import	"PluginManager.h"

@implementation MyApplicationDelegate

-(BOOL) applicationShouldOpenUntitledFile:(NSApplication*) sender {
	return NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// TODO: put a pretty splash screen up
	//[super applicationDidFinishLaunching:aNotification];
	_thePluginManager = [PluginManager sharedInstance];
	NSLog(@"%@", [_thePluginManager _pluginClasses]);
}


@end
