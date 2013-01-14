asfac
=====

A simple, fast IOC container for use in ActionScript projects.

**Getting Started**

In it's simplest form _asfac_ is contained in a single file, _AsFactory.as_. You can simply copy this file into your project to get started.

You can then perform registration and resolution as follows

    var asFactory:AsFactory = new AsFactory();
    asFactory.register(StandardGreeter, ISayHello);
    var greeter:ISayHello = asFactory.resolve(ISayHello);


**Accessing A Common AsFactory From Separate Components**

Obviously, your application components should not create new instances of _AsFactory_, as they would not have prior registrations. You can make the _AsFactory_ available to application components in a variety of ways, but for the sake of getting you off the ground quickly, a locator class is provided.

Simply use the following instance for out of the box management of a global _AsFactory_ for use across your application.

    AsFactoryLocator.factory

***

**Fluent Interface**

Those looking for a fluent registration interface can copy the entire contents of the asfac folder. Upon doing so, you also gain access to a _FluentAsFactoryLocator_ which uses the standard _AsFactory_ internally.

    FluentAsFactoryLocator.factory

***


**Property Injection**

When resolving a type AsFactory will inspect the writable properties for the 'Inject' metadata and set them based on the registered types.

    [Inject]
	public function set users(repo:IUserRepository)
	
Since the Inject metadata is not recognized out of the box you must add the following compiler flag when building your project.

    -keep-as3-metadata+=Inject

***

**Show Me The Code!**

To register a type for an interface (new instance per request)

    // Standard
    factory.register(InMemoryUserRepository, IUserRepository);    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

    // Fluent
    factory.register(InMemoryUserRepository).asType(IUserRepository);
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Register type for instance (singleton instance on each request)
    
    // Standard
    factory.register(InMemoryUserRepository, IUserRepository, true);
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

    // Fluent
    factory.register(InMemoryUserRepository).asType(IUserRepository).asSingleton();
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Register type for instance with a named scope

    // Standard
    factory.register(InMemoryUserRepository, IUserRepository, "memory", true);    
    var userRepository:IUserRepository = factory.resolve(IUserRepository, "memory");

    // Fluent
    factory.inScope("memory").register(InMemoryUserRepository).asType(IUserRepository).asSingleton();
    var userRepository:IUserRepository = factory.fromScope("memory").resolve(IUserRepository);

Register an instance for interface

    // Standard
    factory.register(new InMemoryUserRepository(), IUserRepository);    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

    // Fluent
    factory.register(new InMemoryUserRepository()).asType(IUserRepository);    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Register callback for type

    var buildMyRepository:Function = function(factory:AsFactory, scopeName:String):Object { 
        // ... (build your instance however is appropriate)
        // ... (note that the factory and scope are provided for your use)
    };

    ...

    // Standard
    factory.register(buildMyRepository, IUserRepository);
    var userRepository:IUserRepository = factory.resolve(IUserRepository);
    
    // Fluent
    factory.register(buildMyRepository).asType(IUserRepository);
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Resovle type with property injection

	public class ApplicationContext
	{
		private var _users:IUserRepository;
		
		[Inject]
		public function set users(repo:IUserRepository):void
		{
			_users = repo;
		}
		
		public function get users():IUserRepository
		{
			return _users;
		}
	}
	
	...
	
    // Standard
    factory.register(InMemoryUserRepository, IUserRepository);
    var context:ApplicationContext = factory.resolve(ApplicationContext);

    // Fluent
    factory.register(InMemoryUserRepository).asType(IUserRepository);    
    var context:ApplicationContext = factory.resolve(ApplicationContext);

**License**

This content is released under the MIT License (See LICENSE.txt).