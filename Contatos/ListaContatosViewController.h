//
//  ListaContatosViewController.h
//  Contatos
//
//  Created by Thiago on 3/22/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormularioContatoViewController.h"
#import "ContatoDao.h"
#import "Contato.h"
#import "GerenciadorDeAcoes.h"

/*!
 * Lista de contatos da aplicação.
 */
@interface ListaContatosViewController : UITableViewController<FormularioContatoViewControllerDelegate>

@property (readonly) GerenciadorDeAcoes *gerenciador;

@property (strong) ContatoDao *dao;
@property (strong) Contato *contatoSelecionado;

@property NSInteger linhaDestaque;

- (void) exibirMaisAcoes:(UIGestureRecognizer *)gesture;

@end
