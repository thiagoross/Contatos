//
//  ListaContatosViewController.m
//  Contatos
//
//  Created by Thiago on 3/22/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import "ListaContatosViewController.h"
#import "FormularioContatoViewController.h"

@interface ListaContatosViewController ()

@end

@implementation ListaContatosViewController

- (id) init {
    self = [super initWithNibName:@"ListaContatosViewController" bundle:nil];
    if (self) {
        
        // título
        self.navigationItem.title = @"Contatos";
        
        // considera navigation bar na tela
        self.navigationController.navigationBar.translucent = NO;
        
        // botão adicionar contato
        UIBarButtonItem *botaoAdicionarContato = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(exibirFormularioContato)];
        self.navigationItem.rightBarButtonItem = botaoAdicionarContato;
        
        // botão editar contatos
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        // botão da tab bar
        UIImage *imagemTabItem = [UIImage imageNamed:@"lista-contatos.png"];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"Contatos" image:imagemTabItem tag:0];
        self.tabBarItem = tabItem;
        
        // evento de long press
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(exibirMaisAcoes:)];
        [self.tableView addGestureRecognizer:longPress];
        
        self.dao = [ContatoDao contatoDaoInstance];
        
        self.linhaDestaque = -1;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.linhaDestaque > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.linhaDestaque inSection:0];
    
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
        self.linhaDestaque = -1;
    }
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dao totalContatos];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
    // reaproveita célula, caso exista, para economizar memória
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Contato *contato = [self.dao buscarContatoDaPosicao:indexPath.row];
    cell.textLabel.text = contato.nome;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // deleta registro
        [self.dao removerContatoDaPosicao:indexPath.row];
        
        // deleta linha do data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
//    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    self.contatoSelecionado = [self.dao buscarContatoDaPosicao:indexPath.row];
    [self exibirFormularioContato];
    
    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) exibirMaisAcoes:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint ponto = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:ponto];
        
        if (indexPath) {
            self.contatoSelecionado = [self.dao buscarContatoDaPosicao:indexPath.row];
            
            _gerenciador = [[GerenciadorDeAcoes alloc] initWithContato:self.contatoSelecionado];
            [_gerenciador acoesDoController:self];
        }
    }
}

// Métodos implementados do FormularioContatoViewControllerDelegate

- (void) contatoAtualizado:(Contato *)contato {
    self.linhaDestaque = [self.dao buscarPosicaoDoContato:contato];
}

-(void) contatoAdicionado:(Contato *)contato {
    self.linhaDestaque = [self.dao buscarPosicaoDoContato:contato];
}

// Métodos privados

- (void) exibirFormularioContato {
    FormularioContatoViewController *formulario = [[FormularioContatoViewController alloc] initWithNibName:@"FormularioContatoViewController" bundle:nil];
    
    formulario.delegate = self;
    
    if (self.contatoSelecionado) {
        formulario.contato = self.contatoSelecionado;
    }
    
    [self.navigationController pushViewController:formulario animated:YES];
}

@end
