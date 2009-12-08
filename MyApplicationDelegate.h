#import <Cocoa/Cocoa.h>
#import "PluginManager.h"


@interface MyApplicationDelegate : NSObject {
	PluginManager* _thePluginManager;
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication*) sender;
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification;

@end
