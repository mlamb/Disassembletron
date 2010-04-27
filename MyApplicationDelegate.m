#import "MyApplicationDelegate.h"
#import	"PluginManager.h"

//NSString *DADisplayWindowAlphaKey = @"displayWindowAlpha";
//NSString *DADisplayToolTipsKey = @"displayToolTips";

@implementation MyApplicationDelegate

@synthesize preferencesController;

-(BOOL) applicationShouldOpenUntitledFile:(NSApplication*) sender 
{
	return NO;
}

-(void) applicationDidFinishLaunching:(NSNotification*) aNotification 
{
	// TODO: put a pretty splash screen up
	
	// start up the plugin manager
	_thePluginManager = [PluginManager sharedInstance];


}

#pragma mark -
#pragma mark User defaults

+(void) initialize {    
    NSMutableDictionary* initialValues = [NSMutableDictionary dictionary];
    
    //[initialValues setObject:[NSNumber numberWithInteger:1] forKey:DADisplayWindowAlphaKey];
    //[initialValues setObject:[NSNumber numberWithBool:YES] forKey:DADisplayToolTipsKey];
    
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:initialValues];
}


-(IBAction) showPrefs:sender 
{
    if (preferencesController == nil) 
	{
        preferencesController = [[NSWindowController alloc] initWithWindowNibName:@"Preferences"];
    }
    [preferencesController showWindow:self];
	//[[preferencesController window] makeKeyAndOrderFront:self];
}


@end
