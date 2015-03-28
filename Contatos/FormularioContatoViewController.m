//
//  FormularioContatoViewController.m
//  Contatos
//
//  Created by Thiago on 3/21/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import "FormularioContatoViewController.h"

@interface FormularioContatoViewController ()

@end

@implementation FormularioContatoViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"Cadastro";
    
    self.dao = [ContatoDao contatoDaoInstance];
    
    // modo edição
    if (self.contato) {
        if (self.contato.foto) {
            [self.botaoFoto setBackgroundImage:self.contato.foto forState:UIControlStateNormal];
            [self.botaoFoto setTitle:nil forState:UIControlStateNormal];
        }
        
        self.nome.text = self.contato.nome;
        self.telefone.text = self.contato.telefone;
        self.email.text = self.contato.email;
        self.endereco.text = self.contato.endereco;
        self.latitude.text = [self.contato.latitude stringValue];
        self.longitude.text = [self.contato.longitude stringValue];
        self.site.text = self.contato.site;
        
        UIBarButtonItem *botaoAlterarContato = [[UIBarButtonItem alloc] initWithTitle:@"Alterar" style:UIBarButtonItemStylePlain target:self action:@selector(atualizarContato)];
        self.navigationItem.rightBarButtonItem = botaoAlterarContato;
    }
    // modo criação
    else {
        UIBarButtonItem *botaoCriarContato = [[UIBarButtonItem alloc] initWithTitle:@"Criar" style:UIBarButtonItemStylePlain target:self action:@selector(criarContato)];
        self.navigationItem.rightBarButtonItem = botaoCriarContato;
    }
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Métodos implementados da UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *imagemSelecionada = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [self.botaoFoto setBackgroundImage:imagemSelecionada forState:UIControlStateNormal];
    [self.botaoFoto setTitle:nil forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// Métodos implementados da UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            return;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

// Métodos privados

/**
 *  Recupera dados do formulário e armazena o Contato na view.
 */
- (void) pegaDadosDoFormulario {
    if (!self.contato) {
        self.contato = [self.dao novoContato];
    }
    
    if ([self.botaoFoto backgroundImageForState:UIControlStateNormal]) {
        self.contato.foto = [self.botaoFoto backgroundImageForState:UIControlStateNormal];
    }
    
    self.contato.nome = self.nome.text;
    self.contato.telefone = self.telefone.text;
    self.contato.email = self.email.text;
    self.contato.endereco = self.endereco.text;
    self.contato.latitude = [NSNumber numberWithFloat: [self.latitude.text floatValue]];
    self.contato.longitude = [NSNumber numberWithFloat: [self.longitude.text floatValue]];
    self.contato.site = self.site.text;
}

/**
 *  Cria um novo contato.
 */
- (void) criarContato {
    [self pegaDadosDoFormulario];
    [self.dao adicionarContato:self.contato];
    
    if (self.delegate) {
        [self.delegate contatoAdicionado:self.contato];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Atualiza dados de um contato existente.
 */
- (void) atualizarContato {
    [self pegaDadosDoFormulario];
    
    if (self.delegate) {
        [self.delegate contatoAtualizado:self.contato];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Seleciona imagem imagem ao clicar no botão de foto.
 */
- (IBAction) selecionarFoto:(id)botao {
    // câmera disponível
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *opcoes = [[UIActionSheet alloc] initWithTitle:@"Escolha a foto do contato" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Tirar foto", @"Escolher da biblioteca", nil];
        [opcoes showInView:self.view];
    }
    // somente biblioteca
    else {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

/**
 * Busca coordenadas do endereço especificado no formulário.
 */
- (IBAction) buscarCoordenadas:(UIButton *)botao {
    [self.loading startAnimating];
    botao.hidden = YES;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.endereco.text completionHandler:^(NSArray *resultados, NSError *error) {
        if (error == nil && [resultados count] > 0) {
            CLPlacemark *resultado = resultados[0];
            CLLocationCoordinate2D coordenada = resultado.location.coordinate;
            self.latitude.text = [NSString stringWithFormat:@"%f", coordenada.latitude];
            self.longitude.text = [NSString stringWithFormat:@"%f", coordenada.longitude];
            [self.loading stopAnimating];
            botao.hidden = NO;
        }
    }];
}

@end
