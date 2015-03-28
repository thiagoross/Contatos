//
//  Contato.h
//  Contatos
//
//  Created by Thiago on 3/22/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

/*!
 * Classe que representa um Contato.
 */
@interface Contato : NSManagedObject<MKAnnotation>

@property (strong) UIImage *foto;
@property (strong) NSString *nome;
@property (strong) NSString *telefone;
@property (strong) NSString *email;
@property (strong) NSString *endereco;
@property (strong) NSNumber *latitude;
@property (strong) NSNumber *longitude;
@property (strong) NSString *site;

@end
