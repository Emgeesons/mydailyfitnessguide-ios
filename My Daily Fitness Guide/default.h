//
//  default.h
//  Hinduja
//
//  Created by yogesh on 07/04/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#ifndef Hinduja_default_h
#define Hinduja_default_h

#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define NoInternetConnectionErrorMessage @"Trouble connecting to the internet. Please check your internet connection and try again."

#define RegisterAlertText @"Don't be shy\nfill in your details correctly"

#define titleFont 18.0

#define successImage @"circle_green.png"
#define failureImage @"circle_red.png"
#define grayImage @"circle_grey.png"
#define dropDownImage @"carat-open.png"
#define navigationImage @"navigation.png"

#define lighGrayColor @"#E6E6E6"

#define registerURL @"http://emgeesonsdevelopment.in/goldsgym/mobile2.0/userRegistration.php"
#define stateListURL @"http://emgeesonsdevelopment.in/goldsgym/mobile2.0/getGymCities.php"
#define cityListURL @"http://emgeesonsdevelopment.in/goldsgym/mobile2.0/getGymLocations.php"
#define offersURL @"http://www.goldsgymindia.com/ws/ws.asmx/Offers"
#define eventsURL @"http://www.goldsgymindia.com/ws/ws.asmx/Events"

#define buyMemberShipURL @"http://goldsgymindia.com/sc.asp"
#define vipPass @"http://goldsgymindia.com/"

#define BlueColor1 @"#18509b"
#define BlueColor2 @"#2f67b1"
#define BlueColor3 @"#457dc7"
#define BlueColor4 @"#5990d8"
#define BlueColor5 @"#77abf0"
#define BlueColor6 @"#8eb9f3"

#define KGS_CONVERSION 2.20462

#define Rate_Us_URL @"https://itunes.apple.com/in/app/my-daily-fitness-guide/id891210343?ls=1&mt=8"

#define IsIphone5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#endif
