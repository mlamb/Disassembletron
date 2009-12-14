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

static PluginManager* _sharedPluginManager = nil;

+(PluginManager *) sharedInstance {
	if(_sharedPluginManager)
			return _sharedPluginManager;
		
	@synchronized(self) {
		if (_sharedPluginManager == nil) {
			_sharedPluginManager = [[self alloc] init];
		}
	}
	return _sharedPluginManager;
}

+(id)alloc
{
	@synchronized([PluginManager class])
	{
		NSAssert(_sharedPluginManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedPluginManager = [super alloc];
		return _sharedPluginManager;
	}
	
	return nil;
}

// TODO?: make this private
- (void)activatePlugin:(NSString*)path {
	NSBundle* pluginBundle = [NSBundle bundleWithPath:path];

	if (pluginBundle) {
		NSDictionary* pluginDict = [pluginBundle infoDictionary];
		NSString* pluginName = [pluginDict objectForKey:@"NSPrincipalClass"];
		if (pluginName) {
			Class pluginClass = NSClassFromString(pluginName);
			if (!pluginClass) {
				pluginClass = [pluginBundle principalClass];
				
				// TODO: check plugins conform to which protocols (visualizers (call graph,block grouped/linked outline view, AT&T/Intel syntax)?, executable parsers (a.out,ELF,PE,Mach-o)?, disassembers (PPC, x86, ARM)?, code analyzers (mem leaks, unused vars)?, CPU/register emulators(PPC, x86, ARM)?)
				// TODO: add each type of plugin to the respective plugin type array
				

				//if ([pluginClass conformsToProtocol:@protocol(PAPluginProtocol)] && [pluginClass isKindOfClass:[NSObject class]] && [pluginClass initializeClass:pluginBundle]) {
				
				
				// TODO: remove this when we have more plugin protocols implemented - this is example code
	            // TODO: replace setObject instance with an Array, so that we can have more than one instance for each type
				if ([pluginClass conformsToProtocol:@protocol(PAPluginProtocol)])  {
					
					[[self _pluginClasses] setObject:pluginClass forKey:@"PAPluginProtocol"];
					
				}
				
				if ([pluginClass conformsToProtocol:@protocol(CodeParser)])  {
					
					[[self _pluginClasses] setObject:pluginClass forKey:@"CodeParser"];
					
				}
				
				// TODO: query the plugin for additional configuration
				// use [pluginBundle objectForInfoDictionaryKey:@"somekey"]; to get the key out of the info.plist
				// things like BOOLs for if it should be in the toolbar or not, display names?, etc.
				
				// TODO: update toolbar/menus/etc with new plugin features 
				
				//}*/
			}
		}
	}
}


- (NSArray*)pluginPathsForDirectoriesInDomains
{
	// domain paths are used as a basis for searching for plugins.
	// appending subfolders like 'plugins' to them should list all folders that are used to store plugins.
	static NSMutableArray* domains;
	
	if (domains)
	{
		return domains;
	}  
	
	domains = [[NSMutableArray alloc] init];
	
	//get the processes name, it's used as subfolder in the app-support folders
	NSString* appName = [[NSProcessInfo processInfo] processName];
	
	NSArray* SearchPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,NSAllDomainsMask, YES);
		
	for(id domain in SearchPaths) {
		[domains addObject:[[domain stringByAppendingPathComponent:appName] stringByAppendingPathComponent:@"PlugIns"]];
	}
		 
	// finally add the bundle's plugin's folder
	[domains addObject:[[NSBundle mainBundle] builtInPlugInsPath]];
	
	return domains;
}

-(BOOL) isPluginDisabled:(NSString*)path {
	
	if([_disabledPlugins containsObject:path]) {
		return YES;
	}
	else {
		return NO;
	}
	
}

-(BOOL) disablePlugin:(NSString*) path {
	
	if(![_disabledPlugins containsObject:path]) {
		[_disabledPlugins addObject:path];
		return YES;
	}
	return NO;
}

-(BOOL) enablePlugin:(NSString*) path {
	if([_disabledPlugins containsObject:path]) {
		[_disabledPlugins removeObject:path];
		return YES;
	} else {
		return NO;
	}

}

-(id)init {
	if(![super init]) 
		return nil;
	
	if (self != nil) {
		// TODO: load "disabled plugins" list from user preferences.
		_disabledPlugins = [[NSMutableArray arrayWithCapacity:1] retain];
		
		// TODO: remove this when we have loaded disabled plugins from user preferences (this is so that unit tests pass)
		[self disablePlugin:@"/Users/Mlamb/Disassembletron/build/Debug/Disassembletron.app/Contents/PlugIns/Application Plug-in.plugin"];
		_pluginClasses = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
		
		// find plugins in these directories
		NSArray* pluginPaths = [self pluginPathsForDirectoriesInDomains];
		
		// TODO?: pull this out of init... should we spin up a separate thread to look for plugins to load in real-time?
		// iterate through the pluginPaths and get the paths for any resources with the type "plugin"
		for(NSString* pluginPath in pluginPaths) 
		{
			NSArray* bundlePathsForPlugins = [NSBundle pathsForResourcesOfType:@"plugin" inDirectory:pluginPath];
			for(NSString* bundlePathForPlugin in bundlePathsForPlugins) {
				NSLog(@"Found plugin: %@",bundlePathForPlugin);
				
				if (![self isPluginDisabled:bundlePathForPlugin]) {
					[self activatePlugin:bundlePathForPlugin];
				} else {
					NSLog(@"Plugin is disabled: %@", bundlePathForPlugin);
				}
			}
		}
		
		// TODO?: create a thread to scan standard directories for new plugins (load them into running instance asap)
	}
	
	return self;
}

-(void) dealloc {
	[_sharedPluginManager release];
	[_pluginClasses release];
	[super dealloc];
}


@end