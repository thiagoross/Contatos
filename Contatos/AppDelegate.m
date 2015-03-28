//
//  AppDelegate.m
//  Contatos
//
//  Created by Thiago on 3/21/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import "AppDelegate.h"
#import "ListaContatosViewController.h"
#import "ContatosNoMapaViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.dao = [ContatoDao contatoDaoInstance];
    
    ListaContatosViewController *lista = [ListaContatosViewController new];
    UINavigationController *navLista = [[UINavigationController alloc] initWithRootViewController:lista];
    
    ContatosNoMapaViewController *contatosNoMapa = [ContatosNoMapaViewController new];
    UINavigationController *navContatosNoMapa = [[UINavigationController alloc] initWithRootViewController:contatosNoMapa];
    
    UITabBarController *tabBar = [UITabBarController new];
    tabBar.viewControllers = @[navLista, navContatosNoMapa];
    
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.dao saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
