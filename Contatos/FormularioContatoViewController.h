//
//  FormularioContatoViewController.h
//  Contatos
//
//  Created by Thiago on 3/21/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "Contato.h"
#import "ContatoDao.h"

@protocol FormularioContatoViewControllerDelegate <NSObject>
    @required
    - (void) contatoAtualizado:(Contato *)contato;
    - (void) contatoAdicionado:(Contato *)contato;
@end

/*!
 * Formulário para a criação de um contato.
 */
@interface FormularioContatoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *botaoFoto;
@property (weak, nonatomic) IBOutlet UITextField *nome;
@property (weak, nonatomic) IBOutlet UITextField *telefone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *endereco;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) IBOutlet UITextField *site;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property (weak) id<FormularioContatoViewControllerDelegate> delegate;

@property (strong) Contato *contato;
@property (strong) ContatoDao *dao;

- (IBAction) selecionarFoto:(id)sender;
- (IBAction) buscarCoordenadas:(id)sender;

@end
