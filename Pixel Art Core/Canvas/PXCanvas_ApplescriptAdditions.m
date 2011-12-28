//
//  PXCanvas_ApplescriptAdditions.m
//  Pixen
//
//  Copyright 2005-2011 Pixen Project. All rights reserved.
//

#import "PXCanvas_ApplescriptAdditions.h"

#import "PXCanvas_Layers.h"
#import "PXCanvas_Modifying.h"
#import "PXLayer.h"

@implementation PXCanvas (ApplescriptAdditions)

- (PXLayer *)layerNamed:(NSString *)name
{
	for (PXLayer *current in layers)
	{
		if ([current.name isEqualToString:name])
			return current;
	}
	
	return nil;
}

- (id)handleAddLayerScriptCommand:(id)command
{
	NSString *name = [[command evaluatedArguments] objectForKey:@"layerName"];
	
	PXLayer *layer = [[PXLayer alloc] initWithName:name size:[self size]];
	
	[self addLayer:layer];
	[layer release];
	
	return nil;
}

- (id)handleGetColorScriptCommand:(id)command
{
	NSDictionary *arguments = [command evaluatedArguments];
	int x = [[arguments objectForKey:@"atX"] intValue];
	int y = [[arguments objectForKey:@"atY"] intValue];
	
	return [self colorAtPoint:NSMakePoint(x, y)];
}

- (id)handleMoveLayerScriptCommand:(id)command
{
	int atIndex = [[[command evaluatedArguments] objectForKey:@"atIndex"] intValue];
	int toIndex = [[[command evaluatedArguments] objectForKey:@"toIndex"] intValue];
	
	[self moveLayer:[layers objectAtIndex:atIndex] toIndex:toIndex];
	
	return nil;
}

- (id)handleRemoveLayerScriptCommand:(id)command
{
	NSString *name = [[command evaluatedArguments] objectForKey:@"layerName"];
	PXLayer *layer = [self layerNamed:name];
	
	if (layer)
		[self removeLayer:layer];
	
	return nil;
}

- (id)handleSetColorScriptCommand:(id)command
{
	NSDictionary *arguments = [command evaluatedArguments];
	NSArray *colorArray = [arguments objectForKey:@"toColor"];
	int x = [[arguments objectForKey:@"atX"] intValue];
	int y = [[arguments objectForKey:@"atY"] intValue];
	
	NSColor *color = [NSColor colorWithCalibratedRed:[[colorArray objectAtIndex:0] floatValue] / 65535
											   green:[[colorArray objectAtIndex:1] floatValue] / 65535
												blue:[[colorArray objectAtIndex:2] floatValue] / 65535
											   alpha:1.0f];
	
	NSPoint changedPoint = NSMakePoint(x, y);
	
	[self setColor:color atPoint:changedPoint];
	[self changedInRect:NSMakeRect(changedPoint.x, changedPoint.y, 1.0f, 1.0f)];
	
	return nil;
}

- (NSString *)activeLayerName
{
	return [self activeLayer].name;
}

- (void)setActiveLayerName:(NSString *)name
{
	PXLayer *layer = [self layerNamed:name];
	
	if (layer)
		[self activateLayer:layer];
}

- (int)height
{
	return (int) [self size].height;
}

- (void)setHeight:(int)height
{
	NSSize newSize = [self size];
	newSize.height = height;
	
	[self setSize:newSize];
}

- (int)width
{
	return (int) [self size].width;
}

- (void)setWidth:(int)width
{
	NSSize newSize = [self size];
	newSize.width = width;
	
	[self setSize:newSize];
}

@end
