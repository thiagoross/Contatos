//
//  ContatosNoMapaViewController.h
//  Contatos
//
//  Created by Thiago on 3/26/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ContatosNoMapaViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (weak, nonatomic) NSMutableArray *contatos;
@property CLLocationManager *manager;

@end
