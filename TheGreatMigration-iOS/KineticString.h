//
//  KineticString.h
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KineticObject.h"

@interface KineticString : KineticObject 
{
    NSString* string;
}

@property(nonatomic)int group;
@property(nonatomic)int parent;
@property(nonatomic, retain)NSString* string;

-(id)initWithString:(NSString*) s;

@end
