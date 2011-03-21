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
	NSString* PluginName;
	NSString* PluginPath;
	NSBundle* PluginBundle;
	//NSMenuItem* PluginMenuItem; // needed??
	//NSToolbarItem* PluginToolbarItem; //needed???

	Class PluginPrincipalClass;
	BOOL PluginEnabled;
	BOOL PluginNibLoaded; // needed??

	// TODO: investigate making this an enum
	NSString* PluginType;
	NSNumber* PluginVersion;
	NSString* PluginShortDescription;
	NSString* PluginFullDescription;
	NSString* PluginAuthor;
	NSString* PluginAuthorEmail;
	NSString* PluginAuthorWebsite;
	id PluginInstance;

}

@property (nonatomic,retain) NSString* PluginName;
@property (nonatomic,retain) NSString* PluginType;
@property (nonatomic,retain) NSString* PluginAuthor;
@property (nonatomic,retain) NSString* PluginAuthorWebsite;
@property (nonatomic,retain) NSNumber* PluginVersion;
@property (nonatomic,retain) NSString* PluginShortDescription;
@property (nonatomic,retain) NSString* PluginFullDescription;
@property (nonatomic,retain) NSString* PluginAuthorEmail;
@property (nonatomic,retain) NSString* PluginPath;
@property (nonatomic,retain) NSBundle* PluginBundle;
@property (nonatomic,retain) Class	PluginPrincipalClass;
@property (nonatomic) BOOL PluginNibLoaded;
@property (nonatomic,retain) id PluginInstance;

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
-(BOOL) disablePlugin:(NSString*) path;
-(BOOL) enablePlugin:(NSString*) path;

@property (nonatomic,retain) NSArray* supportedPluginProtocols;
@property (nonatomic,retain) NSMutableDictionary* plugins;			//	all the plugins accessible by category key


@end

