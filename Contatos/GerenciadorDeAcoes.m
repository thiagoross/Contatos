//
//  GerenciadorDeAcoes.m
//  Contatos
//
//  Created by Thiago on 3/23/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import "GerenciadorDeAcoes.h"

@implementation GerenciadorDeAcoes

- (id) initWithContato:(Contato *)contato {
    self = [super init];
    if (self) {
        self.contato = contato;
    }
    return self;
}

- (void) acoesDoController:(UIViewController *)controller {
    self.controller = controller;
    
    // cria menu com opções
    UIActionSheet *opcoes = [[UIActionSheet alloc] initWithTitle:self.contato.nome delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Ligar", @"Enviar Email", @"Visualizar site", @"Abrir mapa", nil];
    [opcoes showInView:controller.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self ligar];
            break;
        case 1:
            [self enviarEmail];
            break;
        case 2:
            [self abrirSite];
            break;
        case 3:
            [self mostrarMapa];
            break;
        default:
            break;
    }
}

// Métodos implementados do MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

// Métodos privados

- (void) ligar {
    UIDevice *device = [UIDevice currentDevice];
    
    // faz a ligação
    if ([device.model isEqualToString:@"iPhone"]) {
        NSString *numero = [NSString stringWithFormat:@"tel:%@", self.contato.telefone];
        [self abrirAplicativoComURL:numero];
    }
    // exibe mensagem de erro
    else {
        [[[UIAlertView alloc] initWithTitle:@"Impossível fazer ligação" message:@"Seu dispositivo não é um iPhone" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void) enviarEmail {
    // envia email
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *enviadorEmail = [MFMailComposeViewController new];
        
        enviadorEmail.mailComposeDelegate = self;
        
        [enviadorEmail setToRecipients:@[self.contato.email]];
        [enviadorEmail setSubject:@"Awesome Contact App"];
        
        [self.controller presentViewController:enviadorEmail animated:YES completion:nil];
    }
    // exibe mensagem de erro
    else {
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Não é possível enviar e-mails!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void) abrirSite {
    NSString *url = self.contato.site;
    [self abrirAplicativoComURL:url];
}

- (void) mostrarMapa {
    NSString *url = [[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", self.contato.endereco] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self abrirAplicativoComURL:url];
}

- (void) abrirAplicativoComURL:(NSString *) url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
