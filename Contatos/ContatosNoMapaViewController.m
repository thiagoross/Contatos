//
//  ContatosNoMapaViewController.m
//  Contatos
//
//  Created by Thiago on 3/26/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import "ContatosNoMapaViewController.h"
#import "ContatoDao.h"

@interface ContatosNoMapaViewController ()

@end

@implementation ContatosNoMapaViewController

- (id) init {
    self = [super initWithNibName:@"ContatosNoMapaViewController" bundle:nil];
    if (self) {
        // título
        self.navigationItem.title = @"Mapa";
        
        // considera navigationbar na tela
        self.navigationController.navigationBar.translucent = NO;
        
        // botão na tab bar
        UIImage *imagemTabItem = [UIImage imageNamed:@"mapa-contatos.png"];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"Mapa" image:imagemTabItem tag:0];
        self.tabBarItem = tabItem;
        
        // contatos do mapa
        ContatoDao *dao = [ContatoDao contatoDaoInstance];
        self.contatos = dao.contatos;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    MKUserTrackingBarButtonItem *botaoLocalizacao = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapa];
    self.navigationItem.rightBarButtonItem = botaoLocalizacao;
    
    self.manager = [CLLocationManager new];
    [self.manager requestWhenInUseAuthorization];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.mapa addAnnotations:self.contatos];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.mapa removeAnnotations:self.contatos];
}

// Métodos implementados de MKMapViewDelegate

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"pino";
    MKPinAnnotationView *pino = (MKPinAnnotationView *)[self.mapa dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!pino) {
        pino = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
        pino.annotation = annotation;
    }
    
    Contato *contato = (Contato *) annotation;
    pino.pinColor = MKPinAnnotationColorPurple;
    pino.canShowCallout = YES;
    
    if (contato.foto) {
        UIImageView *imagemContato = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
        imagemContato.image = contato.foto;
        pino.leftCalloutAccessoryView = imagemContato;
    }
    
    return pino;
}

@end
