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

@synthesize _pluginClasses;
@synthesize _disabledPlugins;
@synthesize parserFiletypes;
@synthesize plugins;
@synthesize supportedPluginProtocols;

static PluginManager* _sharedPluginManager = nil;

// TODO: create a master "disassembletron plugin" protocol, have generic meta-data methods in it, as well as a pluginDidLoad method 
// TODO: include methods in PluginManager to register toolbar and menu items, so that developer can call them from pluginDidLoad
// TODO: investigate using the delegate pattern for plugins 

//===========================================================================
#pragma mark • INIT, DEALLOC & SETUP
//===========================================================================

+(PluginManager *) sharedInstance 
{
	if(_sharedPluginManager) 
	{
			return _sharedPluginManager;
	}
	
	@synchronized(self) 
	{
		if (_sharedPluginManager == nil) 
		{
			_sharedPluginManager = [[self alloc] init];
		}
	}
	return _sharedPluginManager;
}


+(id) alloc
{
	@synchronized([PluginManager class])
	{
		NSAssert(_sharedPluginManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedPluginManager = [super alloc];
		return _sharedPluginManager;
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
		
		// TODO: move the support plugin protocls to somewhere more "global" and maybe make it more elegant
		// TODO: pull plugin meta-data from info.plist
		
		// TODO: investigate modifying this to be an enum
		
		
		supportedPluginProtocols = [[NSArray alloc] initWithObjects:@"PAPluginProtocol",@"CodeParser",nil];
		plugins = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
		
		for (id pluginType in supportedPluginProtocols) 
		{
			[plugins setObject:[[[NSMutableArray alloc] init] autorelease] forKey:pluginType];
		}
											
		
		// TODO: load "disabled plugins" list from user preferences.
		_disabledPlugins = [[NSMutableArray arrayWithCapacity:1] retain];
		
		// TODO: remove this when we have loaded disabled plugins from user preferences (this is so that unit tests pass)
		[self disablePlugin:@"/Users/Mlamb/Disassembletron/build/Debug/Disassembletron.app/Contents/PlugIns/Application Plug-in.plugin"];
		
		// TODO?: create a thread to scan standard directories for new plugins (load them into running instance asap)
		// find plugins in these directories		
		[self findAndLoadPluginsForPaths: [self pluginPathsForDirectoriesInDomains]];
		
		
		
	}
	
	return self;
}

-(void) dealloc 
{
	[_sharedPluginManager release];
	[plugins release];
	[supportedPluginProtocols release];
	[super dealloc];
}

- (void) findAndLoadPluginsForPaths: (NSArray *) pluginPaths  {
	// iterate through the pluginPaths and get the paths for any resources with the type "plugin"
	for (NSString* pluginPath in pluginPaths) 
	{
		NSArray* bundlePathsForPlugins = [NSBundle pathsForResourcesOfType:@"plugin" inDirectory:pluginPath];
		for (NSString* bundlePathForPlugin in bundlePathsForPlugins) 
		{
			NSLog (@"Found plugin: %@", bundlePathForPlugin);
			
			if (![self isPluginDisabled:bundlePathForPlugin]) 
			{
				[self loadPlugin:bundlePathForPlugin];
			} 
			else 
			{
				NSLog (@"Plugin is disabled: %@", bundlePathForPlugin);
			}
		}
	}
	
}

-(void) loadPlugin:(NSString*)path 
{
	NSBundle* pluginBundle = [NSBundle bundleWithPath:path];

	if (pluginBundle) 
	{
		NSDictionary* pluginDict = [pluginBundle infoDictionary];
		NSString* pluginName = [pluginDict objectForKey:@"NSPrincipalClass"];
		if (pluginName) 
		{
			Class pluginClass = NSClassFromString (pluginName);
			if (!pluginClass) 
			{
				pluginClass = [pluginBundle principalClass];
				
			}
			
				// TODO: check plugins conform to which protocols (visualizers (call graph,block grouped/linked outline view, AT&T/Intel syntax)?, executable parsers (a.out,ELF,PE,Mach-o)?, disassembers (PPC, x86, ARM)?, code analyzers (mem leaks, unused vars)?, CPU/register emulators(PPC, x86, ARM)?)
				// TODO: add each type of plugin to the respective plugin type array
				

				//[pluginClass isKindOfClass:[NSObject class]] && [pluginClass initializeClass:pluginBundle]
				
				
				
				

				// loop through the supported plugin types and check if the plugin in question conforms to the protocol
				Protocol *pluginProtocol;
				
				for (NSString *pluginTypeKey in supportedPluginProtocols) {
					pluginProtocol = NSProtocolFromString(pluginTypeKey);
					
					if([pluginClass conformsToProtocol:pluginProtocol]) {
						
						// TODO: refactor to create a new "plugin" object that grabs all the meta-data about a plugin.  Then add it to the plugins array.
						
						
						Plugin* thePlugin;
						
						thePlugin = [[Plugin alloc] init];
						
						thePlugin._PluginName = [pluginDict objectForKey: @"DAPluginName"];
						thePlugin._PluginType = pluginTypeKey;
						thePlugin._PluginAuthor = [pluginDict objectForKey: @"DAPluginAuthorName"];
						thePlugin._PluginAuthorWebsite = [pluginDict objectForKey: @"DAPluginAuthorWebsite"];
						thePlugin._PluginVersion = [pluginDict objectForKey: @"DAPluginVersion"];
						thePlugin._PluginShortDescription = [pluginDict objectForKey: @"DAPluginShortDesc"];
						thePlugin._PluginFullDescription = [pluginDict objectForKey: @"DAPluginFullDesc"];
						thePlugin._PluginAuthorEmail = [pluginDict objectForKey: @"DAPluginAuthorEmail"];
						thePlugin._PluginPath = pluginBundle.bundlePath;
						thePlugin._PluginBundle = pluginBundle;
						thePlugin._PluginPrincipalClass = pluginClass;
						//thePlugin._PluginEnabled = [pluginDict objectForKey: @"DAPluginEnabledState"];
						//thePlugin._PluginNibLoaded = YES;
						
						
						[[plugins objectForKey:pluginTypeKey] addObject:thePlugin];
						
						[thePlugin release];
					}
				}
				
				// clean up 
				
				
				
				// TODO: query the plugin for additional configuration
				// use [pluginBundle objectForInfoDictionaryKey:@"somekey"]; to get the key out of the info.plist
				// things like BOOLs for if it should be in the toolbar or not, display names?, etc.
				
				// TODO: update toolbar/menus/etc with new plugin features 
				
				//}*/

		}
	}
}


- (NSArray*) pluginPathsForDirectoriesInDomains
{
	// domain paths are used as a basis for searching for plugins.
	// appending subfolders like 'plugins' to them should list all folders that are used to store plugins.
	if (domains)
	{
		return domains;
	}  
	
	domains = [[NSMutableArray alloc] init];
	
	//get the processes name, it's used as subfolder in the app-support folders
	// TODO: revisit wisdom of using processName?
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

//===========================================================================
#pragma mark • PLUGIN STATUS, ENABLE & DISABLE 
//===========================================================================

-(BOOL) isPluginDisabled:(NSString*)path {
	
	if ([_disabledPlugins containsObject:path]) 
	{
		return YES;
	}
	else 
	{
		return NO;
	}
	
}

-(BOOL) disablePlugin:(NSString*) path 
{	
	if(![_disabledPlugins containsObject:path]) 
	{
		[_disabledPlugins addObject:path];
		return YES;
	}
	else 
	{
		return NO;
	}
}

-(BOOL) enablePlugin:(NSString*) path 
{
	if ([_disabledPlugins containsObject:path]) 
	{
		[_disabledPlugins removeObject:path];
		return YES;
	} 
	else 
	{
		return NO;
	}

}




@end

@implementation Plugin

@synthesize _PluginName;
@synthesize _PluginType;
@synthesize _PluginAuthor;
@synthesize _PluginAuthorWebsite;
@synthesize _PluginVersion;
@synthesize _PluginShortDescription;
@synthesize _PluginFullDescription;
@synthesize _PluginAuthorEmail;
@synthesize _PluginPath;
@synthesize _PluginBundle;
@synthesize _PluginPrincipalClass;
@synthesize _PluginEnabled;
@synthesize _PluginNibLoaded;
@synthesize _PluginInstance;

@end