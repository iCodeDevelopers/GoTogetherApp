//
//  NSManagedObject+JSON.m
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/18/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "NSManagedObject+JSON.h"
#import <objc/runtime.h>
#import "GTAppDelegate.h"

@implementation NSManagedObject (JSON)

+ (instancetype)createModelContext
{
	return [NSEntityDescription
				  insertNewObjectForEntityForName:NSStringFromClass([self class])
				  inManagedObjectContext:[APP_DELEGATE managedObjectContext]];
}

- (NSString *)toJSONString
{
	NSMutableDictionary *dicti = [NSMutableDictionary new];

	unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);

            NSString *propertyName = [NSString stringWithCString:propName
														encoding:[NSString defaultCStringEncoding]];
            NSString *propertyType = [NSString stringWithCString:propType
														encoding:[NSString defaultCStringEncoding]];

			id propertyObject = [self performSelector:NSSelectorFromString(propertyName) withObject:nil];

			if (propertyName && propertyObject) {
				[dicti setObject:propertyObject forKey:propertyName];
			}
        }
    }

	NSError *writeError = nil;
	NSArray* objects = [NSArray arrayWithObjects:dicti, nil];
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:objects options:NSJSONWritingPrettyPrinted error:&writeError];
	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

	return jsonString;
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}
@end
