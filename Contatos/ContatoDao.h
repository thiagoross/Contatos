//
//  ContatoDao.h
//  Contatos
//
//  Created by Thiago on 3/22/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Contato.h"

/*!
 * Classe que controla o acesso aos Contatos armazenados na aplicação.
 */
@interface ContatoDao : NSObject

@property (strong, readonly) NSMutableArray *contatos;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*!
 * @discussion Instancia um objeto ContatoDao.
 * @return id Retorna uma intância única de ContatoDao
 */
+ (id) contatoDaoInstance;

/*!
 * @discussion Cria um novo contato já como entidade do banco de dados.
 * @return contato Contato criado
 */
- (Contato *) novoContato;

/*!
 * @discussion Adiciona contato à lista de contatos.
 * @param contato Contato a ser adicionado
 */
- (void) adicionarContato:(Contato *)contato;

/*!
 * @discussion Remove contato da lista de contatos.
 * @param posicao Index do contato na lista
 */
- (void) removerContatoDaPosicao:(NSInteger)posicao;

/*!
 * @discussion Recupera contato da posição passada.
 * @param posicao Index do contato na lista
 * @return contato Contato encontrado
 */
- (Contato *) buscarContatoDaPosicao:(NSInteger)posicao;

/*!
 * @discussion Recuperar a posição de um contato no array.
 * @param contato Contato a ser procurado no array
 * @return index Inteiro com a posição do contato
 */
- (NSInteger) buscarPosicaoDoContato:(Contato *)contato;

/*!
 * @discussion Retorna o total de contatos da aplicação.
 * @return (NSInteger) Total de contatos
 */
- (NSInteger) totalContatos;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
