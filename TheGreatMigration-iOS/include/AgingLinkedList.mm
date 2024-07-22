//
//  AgingLinkedList.m
//  TheGreatMigration-iOS
//
//  Created by c-a on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AgingLinkedList.h"

@implementation AgingLinkedList

- (id)init
{
    self = [super init];
    if (self) {
        theList = [[[CHSinglyLinkedList alloc] init] retain];
        recycledList = [[[CHSinglyLinkedList alloc] init] retain];
    }
    
    return self;
}

//constructor
-(id)initWithDuration:(float)Death
{
    self = [super init];
    if (self) {
        death = Death;
        theList = [[[CHSinglyLinkedList alloc] init] retain];
        recycledList = [[[CHSinglyLinkedList alloc] init] retain];
    }

    return self;
}

-(void)dealloc {
    [theList release];
    [recycledList release];
    
    [super dealloc];
}

//add an object
-(void)add:(KineticObject*)obj
{
    [theList addObject:obj];
//    int c = [theList count];
//    NSLog(@"was added?");
}

//update the list and its objects
-(void) update:(float)dt
{
    NSMutableArray *deadObjects = [NSMutableArray array];
    
    NSEnumerator *it = [theList objectEnumerator];
    KineticObject *obj = nil;
    while ((obj = [it nextObject])) {
        [obj update:dt];
        
        //if the object is too old, then remove it
        //and recycle it
        if ([obj age] >= death) {
            [obj kill];
            [deadObjects addObject:obj];
            //[theList removeObject:obj];
            //[recycledList addObject:obj];
        }
    }

    NSEnumerator *deadit = [deadObjects objectEnumerator];
    while((obj = [deadit nextObject])) {
        [theList removeObject:obj];
        [recycledList addObject:obj];
    }
}

//get a recycled object if any
-(KineticObject*)recycle
{
    if ([[recycledList allObjects] count] == 0) return nil;
    
    tmpObj = [recycledList firstObject];
    [recycledList removeFirstObject];
    return (KineticObject*)tmpObj;
}

//get the number of objects in the list
-(int)count { return [theList count]; }

//get the object enumerator for thelist
-(NSEnumerator*)objectEnumerator { return [theList objectEnumerator]; }

@end
