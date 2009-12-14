//
//  SingletonTest.h
//  Disassembletron
//
//  Created by Michael Lamb on 9/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface PluginManager : NSObject {
	//NSMutableArray* _pluginClasses;
	NSMutableDictionary* _pluginClasses;
	NSMutableArray* _disabledPlugins;
}

+(id)alloc;
-(id)init;
+(PluginManager *) sharedInstance;


-(NSArray*) pluginPathsForDirectoriesInDomains;
-(void) activatePlugin:(NSString *)path;
-(BOOL) isPluginDisabled:(NSString *)path;
-(BOOL) disablePlugin:(NSString *)path;
-(BOOL) enablePlugin:(NSString *)path;


@property (nonatomic,retain) NSMutableArray* _disabledPlugins;		//	an array of stuff
@property (nonatomic,retain) NSMutableDictionary* _pluginClasses;		//	an array of stuff
@end
