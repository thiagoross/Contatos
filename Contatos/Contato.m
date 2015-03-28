//
//  Contato.m
//  Contatos
//
//  Created by Thiago on 3/22/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import "Contato.h"

@implementation Contato

@dynamic nome, telefone, email, endereco, latitude, longitude, site, foto;

- (NSString *) description {
    return [NSString stringWithFormat:@"Nome: %@, Telefone: %@, Email: %@, Endereco: %@, Site: %@", self.nome, self.telefone, self.email, self.endereco, self.site];
}

// Métodos implementados de MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *) title {
    return self.nome;
}

- (NSString *) subtitle {
    return self.email;
}

@end
