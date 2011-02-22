#import "MyApplicationDelegate.h"
#import	"PluginManager.h"
#import "PreferencesController.h"

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

-(IBAction) openDocument: (id) sender {
	
	NSOpenPanel*    thePanel    = [NSOpenPanel openPanel];
	
	[thePanel setTreatsFilePackagesAsDirectories: YES];
	[thePanel setCanChooseDirectories: YES];
	
	if ([thePanel runModalForTypes: nil] != NSFileHandlingPanelOKButton)
		return;
	
	NSString*   theName = [[thePanel filenames] objectAtIndex: 0];
	
	NSRunAlertPanel(@"filename = " , theName, @"Ok", nil, nil);
	
	NSError* myError; 
	
	[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL: [NSURL fileURLWithPath: theName] display: YES error:&myError];
	
} 


-(IBAction) showPrefs:sender 
{
    if (preferencesController == nil) 
	{
        preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
    }
	NSToolbarItem* theToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Plugins"];
	[theToolbarItem setLabel:@"Plugins"];
	
	//DebugLog(@"theToolbar = ", [preferencesController theToolbar]);
	[[preferencesController theToolbar] insertItemWithItemIdentifier:@"Plugins" atIndex:1];
    [preferencesController showWindow:self];
	[theToolbarItem release];
	//[[preferencesController window] makeKeyAndOrderFront:self];
}


@end
