//
//  ContatoDao.m
//  Contatos
//
//  Created by Thiago on 3/22/15.
//  Copyright (c) 2015 Rossener. All rights reserved.
//

#import "ContatoDao.h"

@implementation ContatoDao

static ContatoDao *_self = nil;

+ (id) contatoDaoInstance {
    if (!_self) {
        _self = [ContatoDao new];
    }
    return _self;
}

- (id) init {
    [self inserirDadosIniciais];
    [self carregarContatos];
    return self;
}

- (Contato *) novoContato {
    return [NSEntityDescription insertNewObjectForEntityForName:@"Contato" inManagedObjectContext:self.managedObjectContext];
}

- (void) adicionarContato:(Contato *)contato {
    [_contatos addObject:contato];
}

-(void) removerContatoDaPosicao:(NSInteger)posicao {
    [_contatos removeObjectAtIndex:posicao];
}

- (Contato *) buscarContatoDaPosicao:(NSInteger)posicao {
    return [_contatos objectAtIndex:posicao];
}

- (NSInteger) buscarPosicaoDoContato:(Contato *)contato {
    return [_contatos indexOfObject:contato];
}

- (NSInteger) totalContatos {
    return [_contatos count];
}

// Métodos privados

/**
 * Insere um contato inicial na aplicação.
 */
- (void) inserirDadosIniciais {
    NSUserDefaults *configuracoes = [NSUserDefaults standardUserDefaults];
    BOOL dadosInseridos = [configuracoes boolForKey:@"dados_inseridos"];
    NSLog(@"passou aqui");
    if (!dadosInseridos) {
        NSLog(@"caiu aqui dentro");
        Contato *meuContato = [self novoContato];
        meuContato.nome = @"Sherlock Holmes";
        meuContato.telefone = @"123456789";
        meuContato.email = @"sherlock@holmes.com";
        meuContato.endereco = @"221B, Baker Street, London";
        meuContato.site = @"http://www.sherlockholmes.com/";
        meuContato.latitude = [NSNumber numberWithDouble:51.5234];
        meuContato.longitude = [NSNumber numberWithDouble:-0.1584];
        
        [self saveContext];
        [configuracoes setBool:YES forKey:@"dados_inseridos"];
        [configuracoes synchronize];
    }
}

/**
 * Carrega contatos do banco de dados.
 */
- (void) carregarContatos {
    NSFetchRequest *buscaContatos = [NSFetchRequest fetchRequestWithEntityName:@"Contato"];
    NSSortDescriptor *ordenaPorNome = [NSSortDescriptor sortDescriptorWithKey:@"nome" ascending:YES];
    
    buscaContatos.sortDescriptors = @[ordenaPorNome];
    
    NSArray *contatosImutaveis = [self.managedObjectContext executeFetchRequest:buscaContatos error:nil];
    _contatos = [contatosImutaveis mutableCopy];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.rossener.Contatos" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Contatos" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Contatos.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
