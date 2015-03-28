//
//  AppDelegate.h
//  Contatos
//
//  Created by Thiago on 3/21/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContatoDao.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property ContatoDao *dao;

@end

