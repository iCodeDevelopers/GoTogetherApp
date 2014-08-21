//
//  Constants.h
//  GoTogetherApp
//
//  Created by MSPiMac2 on 8/19/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

// For user
static NSString * const kRedisUser = @"user";
static NSString * const kRedisUserID = @"userid";
static NSString * const kRedisUserPassword = @"password";
static NSString * const kRedisUserFirstName = @"firstname";
static NSString * const kRedisUserLastName = @"lastname";
static NSString * const kRedisUserGender = @"gender";

#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"
