//
//  GerenciadorDeAcoes.h
//  Contatos
//
//  Created by Thiago on 3/23/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Contato.h"

/*!
 * Gerencia ações do usuário para um determinado contato, como ligar, mostrar no mapa, enviar e-mail e abrir site.
 */
@interface GerenciadorDeAcoes : NSObject<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

@property Contato *contato;
@property UIViewController *controller;

/*!
 * @discussion Instancia um novo gerenciador.
 * @param contato Contato sobre o qual irão agir as ações
 * @return id Instância do gerenciador
 */
- (id) initWithContato:(Contato *)contato;

/*!
 * @discussion Exibe menu de opções de contato para o usuário.
 * @param controller ViewController de onde serão exibidas as opções
 */
- (void) acoesDoController:(UIViewController *)controller;

@end
