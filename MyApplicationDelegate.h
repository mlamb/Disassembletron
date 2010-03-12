#import <Cocoa/Cocoa.h>
#import "PluginManager.h"


@interface MyApplicationDelegate : NSObject 
{
	PluginManager* _thePluginManager;
	NSWindowController *preferencesController;
}

@property (nonatomic, retain) NSWindowController *preferencesController;

-(BOOL) applicationShouldOpenUntitledFile:(NSApplication*) sender;
-(void) applicationDidFinishLaunching:(NSNotification*) aNotification;
-(IBAction) showPrefs: sender;	

@end
