//
//  SHKItem.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/18/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKItem.h"
#import "SHK.h"


@interface SHKItem()
@property (nonatomic, retain)	NSMutableDictionary *custom;
@end


@implementation SHKItem

@synthesize shareType;
@synthesize URL, image, title, text, tags, data, mimeType, filename;
@synthesize custom;

- (void)dealloc
{
	[URL release];
	
	[image release];
	
	[title release];
	[text release];
	[tags release];
	
	[data release];
	[mimeType release];
	[filename release];
	
	[custom release];
	
	[super dealloc];
}


+ (SHKItem *)URL:(NSURL *)url
{
	return [self URL:url title:nil];
}

+ (SHKItem *)URL:(NSURL *)url title:(NSString *)title
{
	SHKItem *item = [[SHKItem alloc] init];
	item.shareType = SHKShareTypeURL;
	item.URL = url;
	item.title = title;
	
	return [item autorelease];
}

+ (SHKItem *)image:(UIImage *)image
{
	return [SHKItem image:image title:nil];
}

+ (SHKItem *)image:(UIImage *)image title:(NSString *)title
{
	SHKItem *item = [[SHKItem alloc] init];
	item.shareType = SHKShareTypeImage;
	item.image = image;
	item.title = title;
	
	return [item autorelease];
}

+ (SHKItem *)text:(NSString *)text
{
	SHKItem *item = [[SHKItem alloc] init];
	item.shareType = SHKShareTypeText;
	item.text = text;
	
	return [item autorelease];
}

+ (SHKItem *)file:(NSData *)data filename:(NSString *)filename mimeType:(NSString *)mimeType title:(NSString *)title
{
	SHKItem *item = [[SHKItem alloc] init];
	item.shareType = SHKShareTypeFile;
	item.data = data;
	item.filename = filename;
	item.mimeType = mimeType;
	item.title = title;
	
	return [item autorelease];
}

#pragma mark -


- (void)setCustomValue:(NSString *)value forKey:(NSString *)key
{
	if (custom == nil)
		self.custom = [NSMutableDictionary dictionaryWithCapacity:0];
	
	if (value == nil)
		[custom removeObjectForKey:key];
		
	else
		[custom setObject:value forKey:key];
}

- (NSString *)customValueForKey:(NSString *)key
{
	return [custom objectForKey:key];
}

- (BOOL)customBoolForSwitchKey:(NSString *)key
{
	return [[custom objectForKey:key] isEqualToString:SHKFormFieldSwitchOn];
}


#pragma mark -

+ (SHKItem *)itemFromDictionary:(NSDictionary *)dictionary
{
	SHKItem *item = [[SHKItem alloc] init];
	item.shareType = [[dictionary objectForKey:@"shareType"] intValue];	
	
	if ([dictionary objectForKey:@"URL"] != nil)
		item.URL = [NSURL URLWithString:[dictionary objectForKey:@"URL"]];
	
	item.title = [dictionary objectForKey:@"title"];
	item.text = [dictionary objectForKey:@"text"];
	item.tags = [dictionary objectForKey:@"tags"];	
		
	if ([dictionary objectForKey:@"custom"] != nil)
		item.custom = [[[dictionary objectForKey:@"custom"] mutableCopy] autorelease];
	
	return [item autorelease];
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
		
	[dictionary setObject:[NSNumber numberWithInt:shareType] forKey:@"shareType"];
	
	if (custom != nil)
		[dictionary setObject:custom forKey:@"custom"];
	
	if (URL != nil)
		[dictionary setObject:[URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"URL"];
	 
	 if (title != nil)
		[dictionary setObject:title forKey:@"title"];
	 
	 if (text != nil)		 
		 [dictionary setObject:text forKey:@"text"];
	
	if (tags != nil)
		[dictionary setObject:tags forKey:@"tags"];
	
	// If you add anymore, make sure to add a method for retrieving them to the itemWithDictionary function too
	
	return dictionary;
}

@end
