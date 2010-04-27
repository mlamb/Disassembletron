//
//  PluginManager.h
//  Disassembletron
//
//  Created by Michael Lamb on 8/10/09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//

#import "Disassembletron.h"
#import <Foundation/Foundation.h>

@interface Plugin : NSObject
{
	NSString* _PluginName;
	NSString* _PluginPath;
	NSBundle* _PluginBundle;
	//NSMenuItem* _PluginMenuItem; // needed??
	//NSToolbarItem* _PluginToolbarItem; //needed???
	
	Class _PluginPrincipalClass;
	BOOL _PluginEnabled;
	BOOL _PluginNibLoaded; // needed??
	
	// TODO: investigate making this an enum
	NSString* _PluginType;
	NSNumber* _PluginVersion;
	NSString* _PluginShortDescription;
	NSString* _PluginFullDescription;
	NSString* _PluginAuthor;
	NSString* _PluginAuthorEmail;
	NSString* _PluginAuthorWebsite;
	id _PluginInstance;
	
}

@property (nonatomic,retain) NSString* _PluginName;
@property (nonatomic,retain) NSString* _PluginType;
@property (nonatomic,retain) NSString* _PluginAuthor;
@property (nonatomic,retain) NSString* _PluginAuthorWebsite;
@property (nonatomic,retain) NSNumber* _PluginVersion;
@property (nonatomic,retain) NSString* _PluginShortDescription;
@property (nonatomic,retain) NSString* _PluginFullDescription;
@property (nonatomic,retain) NSString* _PluginAuthorEmail;
@property (nonatomic,retain) NSString* _PluginPath;
@property (nonatomic,retain) NSBundle* _PluginBundle;
@property (nonatomic,retain) Class	_PluginPrincipalClass;
@property (nonatomic) BOOL _PluginEnabled;
@property (nonatomic) BOOL _PluginNibLoaded;
@property (nonatomic,retain) id _PluginInstance;

//TODO: implement initialization methods with sane defaults for ivars
@end



@interface PluginManager : NSObject 
{
	NSMutableDictionary* plugins;
	NSMutableArray* disabledPlugins;
	NSMutableArray* domains;
	NSArray* parserFiletypes;
	NSArray *supportedPluginProtocols;
}

+(id)alloc;
-(id)init;
+(PluginManager*) sharedInstance;
- (void) findAndLoadPluginsForPaths: (NSArray *) pluginPaths;

-(Plugin *) pluginForFileType: (NSString*) fileType;

-(NSArray*) pluginPathsForDirectoriesInDomains;
-(void) loadPlugin:(NSString*) path;
-(BOOL) isPluginDisabled:(NSString*) path;
-(BOOL) disablePlugin:(NSString*) path;
-(BOOL) enablePlugin:(NSString*) path;

@property (nonatomic,retain) NSArray* supportedPluginProtocols;
@property (nonatomic,retain) NSMutableDictionary* plugins;			//	all the plugins accessible by category key
@property (nonatomic,retain) NSMutableArray* disabledPlugins;		//	an array of disabled plugins		
@property (nonatomic,retain) NSArray* parserFiletypes;

@end

