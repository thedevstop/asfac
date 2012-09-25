asfac
=====

A simple, fast IOC container for use in ActionScript projects.

**Getting Started**

In it's simplest form _asfac_ is contained in a single file AsFactory.as. You can simply copy this file into your project to get started. 

Those looking for a fluent registration interface can copy the entire contents of the asfac folder.

**AsFactory Examples**

Register type for interface.

    var factory:AsFactory = new AsFactory();
    factory.registerType(InMemoryUserRepository, IUserRepository);
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Register type for instance as singleton.

    var factory:AsFactory = new AsFactory();
    factory.registerType(InMemoryUserRepository, IUserRepository, true);
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);
    
Register type for instace with a named scope.

    var factory:AsFactory = new AsFactory();
    factory.registerType(InMemoryUserRepository, IUserRepository, "memory", true);
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository, "memory");

Register instance for interface.

    var factory:AsFactory = new AsFactory();
    factory.registerInstance(new InMemoryUserRepository(), IUserRepository);
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Register callback for type.

    var factory:AsFactory = new AsFactory();
	var callback:Function = function():Object { return new InMemoryUserRepository(); };	
    factory.registerCallback(callback, IUserRepository, true);
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Resovle type with property injection.

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
	
    var factory:AsFactory = new AsFactory();
    factory.registerType(InMemoryUserRepository, IUserRepository, true);
    
    var context:ApplicationContext = factory.resolve(ApplicationContext);

**FluentAsFactory Examples**

Register type for interface.

    var factory:FluentAsFactory = new FluentAsFactory();
    factory.register(InMemoryUserRepository).asType(IUserRepository);
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Register type for instance as singleton.

    var factory:FluentAsFactory = new FluentAsFactory();
    factory.register(InMemoryUserRepository).asType(IUserRepository).asSingleton();
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);
    
Register type for instace with a named scope.

    var factory:FluentAsFactory = new FluentAsFactory();
    factory.inScope("memory").register(InMemoryUserRepository).asType(IUserRepository).asSingleton();
    
    var userRepository:IUserRepository = factory.fromScope("memory").resolve(IUserRepository);

Register instance for interface.

    var factory:FluentAsFactory = new FluentAsFactory();
    factory.register(new InMemoryUserRepository()).asType(IUserRepository);
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Register callback for type.

    var factory:FluentAsFactory = new FluentAsFactory();
	var callback:Function = function():Object { return new InMemoryUserRepository(); };	
    factory.register(callback).asType(IUserRepository).asSingleton();
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

Resovle type with property injection.

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
	
    var factory:FluentAsFactory = new FluentAsFactory();
    factory.register(InMemoryUserRepository).asType(IUserRepository).asSingleton();
    
    var context:ApplicationContext = factory.resolve(ApplicationContext);

**License**

This content is released under the MIT License (See LICENSE.txt).