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

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{

	NSToolbarItem* theToolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:@"Plugins"] autorelease];
	[theToolbarItem setLabel:@"Plugins"];
	[theToolbarItem setImage:[NSImage imageNamed:@"plugin.png"]];
	[theToolbarItem setEnabled:YES];
	return theToolbarItem;
}


-(IBAction) showPrefs: (id) sender {

    if (preferencesController == nil)
	{
        preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
    }
	[preferencesController showWindow:self];
	[[preferencesController theToolbar] setDelegate: self];
	[[preferencesController theToolbar] insertItemWithItemIdentifier:@"Plugins" atIndex:1];

}


@end
