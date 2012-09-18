asfac
=====

A simple, fast IOC container for use in ActionScript projects.

**Getting Started**

In it's simplest form _asfac_ is contained in a single file AsFactory.as. You can simply copy this file into your project to get started. 

Those looking for a fluent registration interface can copy the entire contents of the asfac folder.

**Example**

Register type for interface.

    var factory:AsFactory = new AsFactory();
    factory.registerType(InMemoryUserRepository, IUserRepository);
    
    var userRepository:IUserRepository = factory.resolve(IUserRepository);

**License**

This content is released under the MIT License (See LICENSE.txt).