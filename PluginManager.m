//
//  SingletonTest.m
//  Disassembletron
//
//  Created by Michael Lamb on 9/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PluginManager.h"
#import "CodeParser.h"
#import "PluginInterface.h"

@implementation PluginManager

@synthesize plugins;
@synthesize supportedPluginProtocols;

static PluginManager* sharedPluginManager = nil;

// TODO: create a master "disassembletron plugin" protocol, have generic meta-data methods in it, as well as a pluginDidLoad method
// TODO: include methods in PluginManager to register toolbar and menu items, so that developer can call them from pluginDidLoad
// TODO: investigate using the delegate pattern for plugins

// Plugin Types
// - visualizers (call graph,block grouped/linked outline view, AT&T/Intel syntax)?,
// - executable parsers (a.out,ELF,PE,Mach-o)?,
// - disassembers (PPC, x86, ARM)?,
// - code analyzers (mem leaks, unused vars)?,
// - CPU/register emulators(PPC, x86, ARM)?)

// TODO: figure out how to handle plugin type specific requirements (code parser needs to register file types, how do we do that in a generic loop like in loadPlugins )

//===========================================================================
#pragma mark • INIT, DEALLOC & SETUP
//===========================================================================

+(PluginManager *) sharedInstance
{
	if(sharedPluginManager)
	{
			return sharedPluginManager;
	}

	@synchronized(self)
	{
		if (sharedPluginManager == nil)
		{
			sharedPluginManager = [[self alloc] init];
		}
	}
	return sharedPluginManager;
}


+(id) alloc
{
	@synchronized([PluginManager class])
	{
		NSAssert(sharedPluginManager == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedPluginManager = [super alloc];
		return sharedPluginManager;
	}

	return nil;
}

-(id) init {
	if (![super init])
	{
		return nil;
	}

	if (self != nil)
	{
		// TODO: investigate modifying this to be an enum
		supportedPluginProtocols = [[NSArray alloc] initWithObjects:@"PAPluginProtocol",@"CodeParser",nil];

		plugins = [[NSMutableDictionary dictionaryWithCapacity:1] retain];

		for (id pluginType in supportedPluginProtocols)
		{
			[plugins setObject:[[[NSMutableArray alloc] init] autorelease] forKey:pluginType];
		}

		// find plugins in the standard directories
		[self findAndLoadPluginsForPaths: [self pluginPathsForDirectoriesInDomains]];

	}

	return self;
}

-(void) dealloc
{
	[sharedPluginManager release];
	[plugins release];
	[supportedPluginProtocols release];
	[super dealloc];
}

-(void) findAndLoadPluginsForPaths: (NSArray *) pluginPaths  {

	// iterate through the pluginPaths and get the paths for any resources with the type "plugin"
	for (NSString* pluginPath in pluginPaths)
	{
		// TODO: change this to use custom plugin type so that we can install/register/load plugins with a double-click operation from finder
		NSArray* bundlePathsForPlugins = [NSBundle pathsForResourcesOfType:@"plugin" inDirectory:pluginPath];
		for (NSString* bundlePathForPlugin in bundlePathsForPlugins)
		{
			NSLog (@"Found plugin: %@", bundlePathForPlugin);
			[self loadPlugin:bundlePathForPlugin];
		}
	}

}

-(Plugin*) pluginForFileType: (NSString*) fileType {
	// TODO: conflict resolution.  what do we do if two (or more) plugins register the same file type handled?
	// TODO: rather than searching each plugin, this should be a pluginManager list, and mapped to the plugin that handles it

	NSRunAlertPanel(@"pluginForFileType - " , fileType, @"Ok", nil, nil);
	return [[[Plugin alloc] init] autorelease];

}

-(void) loadPlugin:(NSString*)path {

	NSBundle* pluginBundle = [NSBundle bundleWithPath:path];

	if (pluginBundle)
	{
		NSError *theError = nil;
		if ([pluginBundle preflightAndReturnError:&theError]) {

			[pluginBundle loadAndReturnError:&theError];
			if (theError) {
				[self disablePlugin: (NSString*) path];
				[NSApp presentError:theError];
				return;
			}

			Class pluginClass = [pluginBundle principalClass];

			// loop through the supported plugin types and check if the plugin in question conforms to the protocol
			Protocol *pluginProtocol;

			for (NSString *pluginTypeKey in supportedPluginProtocols) {
				pluginProtocol = NSProtocolFromString(pluginTypeKey);

					// TODO: make a framework, and create an abstract baseclass for all plugins...
					//		then add '&& [pluginClass isSubclassOfClass:[AbstractBaseClass class]]' to this if clause
				if([pluginClass conformsToProtocol:pluginProtocol]) {
					Plugin* thePlugin;

					thePlugin = [[Plugin alloc] init];

					// set all the metadata attributes from the plugin objects info dictionary
					NSDictionary *pluginConfigDict = [pluginBundle objectForInfoDictionaryKey:@"DAPluginConfig"];
					thePlugin.PluginName = [pluginConfigDict objectForKey: @"DAPluginName"];
					thePlugin.PluginType = pluginTypeKey;
					thePlugin.PluginAuthor = [pluginConfigDict objectForKey:  @"DAPluginAuthorName"];
					thePlugin.PluginAuthorEmail = [pluginConfigDict objectForKey:  @"DAPluginAuthorEmail"];
					thePlugin.PluginAuthorWebsite = [pluginConfigDict objectForKey:  @"DAPluginAuthorWebsite"];
					thePlugin.PluginVersion = [pluginConfigDict objectForKey:  @"DAPluginVersion"];
					thePlugin.PluginShortDescription = [pluginConfigDict objectForKey:  @"DAPluginShortDesc"];
					thePlugin.PluginFullDescription = [pluginConfigDict objectForKey:  @"DAPluginFullDesc"];
					thePlugin.PluginPath = pluginBundle.bundlePath;
					thePlugin.PluginBundle = pluginBundle;
					thePlugin.PluginPrincipalClass = pluginClass;

					// TODO: if plugin is a CodeParser, register filetypes handled  - call a "doTypeSpecificSetup/Initialization/Loading" function to keep this method clean and use dependency injection pattern :)

					// Not sure if this is needed yet/at all
					//thePlugin.PluginNibLoaded = YES;

					// add object to the plugins array
					[[plugins objectForKey:pluginTypeKey] addObject:thePlugin];

					// plugins array retained the plugin, so we can safely clean up our reference
					[thePlugin release];
				}
			}
		}

		if (theError) {
			[self disablePlugin: (NSString*) path];
			DebugLog(theError.description);
			[NSApp presentError:theError];
			return;
		}

		// TODO: update toolbar/menus/etc with new plugin features

	}
}


-(NSArray*) pluginPathsForDirectoriesInDomains {
	// domain paths are used as a basis for searching for plugins.
	// appending subfolders like 'plugins' to them should list all folders that are used to store plugins.
	if (domains)
	{
		return domains;
	}

	domains = [[NSMutableArray alloc] init];

	//get the processes name, it's used as subfolder in the app-support folders
	NSString* appName = [[NSProcessInfo processInfo] processName];

	NSArray* SearchPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSAllDomainsMask, YES);

	for (id domain in SearchPaths)
	{
		[domains addObject:[[domain stringByAppendingPathComponent:appName] stringByAppendingPathComponent:@"PlugIns"]];
	}

	// finally add the bundle's plugin's folder
	[domains addObject:[[NSBundle mainBundle] builtInPlugInsPath]];

	return domains;
}


#pragma mark -
#pragma mark - PLUGIN STATUS, ENABLE & DISABLE

-(BOOL) disablePlugin: (NSString*) path {
	// TODO: move the bad plugin to Plugins (Disabled) - create dir if it doesn't exist
	return YES;
}

-(BOOL) enablePlugin: (NSString*) path {
		// TODO: move plugin out of Plugins (Disabled) folder
		// run loadPlugin: on it
	return YES;
}




@end

#pragma mark -
#pragma mark Plugin object definition

@implementation Plugin

@synthesize PluginName;
@synthesize PluginType;
@synthesize PluginAuthor;
@synthesize PluginAuthorWebsite;
@synthesize PluginVersion;
@synthesize PluginShortDescription;
@synthesize PluginFullDescription;
@synthesize PluginAuthorEmail;
@synthesize PluginPath;
@synthesize PluginBundle;
@synthesize PluginPrincipalClass;
@synthesize PluginNibLoaded;
@synthesize PluginInstance;

@end
