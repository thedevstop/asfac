package com.thedevstop.asfac 
{
	import asunit.framework.TestCase;
	import com.thedevstop.asfac.stubs.HasObjectProperty;
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author 
	 */
	public class RegistrationTests extends TestCase
	{
		public function RegistrationTests(testMethod:String = null) 
		{
			super(testMethod);
		}
		
		/*
		 * Should be able to register in the following ways
		 * 
		 * DONE register a concrete instance as a type, so this instance is returned whenever that type is requested
		 * DONE register a type as a type, so that a new instance of that type is returned whenever requested
		 * DONE register a callback as a type, so that the result of the callback is returned whenever requested
		 * 
		 * Scoping
		 * 
		 * should be able to, at registration, say AsSingleton such that only one is ever created, and returned everytime
		 * should be able to, at registration, say PerRequest such that a new is created at each request (default)
		 * 
		 * Is there a need to 
		 * - remove a registration?
		 * - change a registration to use something different?
		 * - parameterize registration, i.e., Register(foo).As(bar).When(baz) so that .Resolve<bar>(baz) gives something different
		 * 		than .Resolve<bar>(meh)
		 */
		
		public function test_should_allow_register_concrete_instance():void
		{
			var factory:AsFactory = new AsFactory();
			
			var instance:Object = { foo:"bar" };
			factory.registerInstance(instance, Object);
			
			var result:Object = factory.resolve(Object);
			assertSame(instance, result);
		}
		
		public function test_should_allow_register_type():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerType(Dictionary, Dictionary);
			
			var result:Object = factory.resolve(Dictionary);
			assertTrue(result.constructor == Dictionary);
		}
		
		public function test_should_allow_register_callback():void
		{
			var factory:AsFactory = new AsFactory();
			
			var source:Array = [1, 2, 3];
			factory.registerCallback(function():Array { return source; }, Array);
			
			var result:Array = factory.resolve(Array);
			assertSame(source, result);			
		}
		
		public function test_should_error_when_registering_callback_with_too_many_arguments():void
		{
			var factory:AsFactory = new AsFactory();
			
			var registerFunc:Function = function():void
			{
				factory.registerCallback(function(asFactory:AsFactory, name:String, num:Number):Array { return [1, 2, 3]; }, Array);
			};
			
			assertThrows(IllegalOperationError, registerFunc);
		}
		
		public function test_should_allow_register_callback_as_singleton():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerCallback(function():Dictionary { return new Dictionary(); }, Dictionary, AsFactory.DefaultScopeName, true);
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertSame(result1, result2);
		}
		
		public function test_should_allow_register_type_as_singleton():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerType(Dictionary, Dictionary, AsFactory.DefaultScopeName, true);
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertSame(result1, result2);
		}
		
		public function test_should_retun_new_instances_when_not_registered_as_singleton():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerType(Dictionary, Dictionary, AsFactory.DefaultScopeName, false);
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertNotSame(result1, result2);
		}
		
		public function test_callbacks_should_allow_register_type_as_singleton():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerCallback(function():Dictionary { return new Dictionary(); }, Dictionary, AsFactory.DefaultScopeName, true);
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertSame(result1, result2);
		}
		
		public function test_callbacks_should_retun_new_instances_when_not_registered_as_singleton():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerCallback(function():Dictionary { return new Dictionary(); }, Dictionary, AsFactory.DefaultScopeName, false);
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertNotSame(result1, result2);
		}
		
		public function test_should_error_when_registering_type_is_null():void
		{
			var factory:AsFactory = new AsFactory();
			
			var registerFunc:Function = function():void
			{
				factory.registerType(Dictionary, null);
			};
			
			assertThrows(IllegalOperationError, registerFunc);			
		}
		
		public function test_should_error_when_instance_type_is_null():void
		{
			var factory:AsFactory = new AsFactory();
			
			var registerFunc:Function = function():void
			{
				factory.registerType(null, Dictionary);
			};
			
			assertThrows(IllegalOperationError, registerFunc);			
		}
		
		public function test_should_error_when_callback_is_null():void
		{
			var factory:AsFactory = new AsFactory();
			
			var registerFunc:Function = function():void
			{
				factory.registerCallback(null, Dictionary);
			};
			
			assertThrows(IllegalOperationError, registerFunc);					
		}
		
		public function test_register_should_register_type():void
		{
			var factory:AsFactory = new AsFactory();
			factory.register(Dictionary, Dictionary);
			
			var instance:Dictionary = factory.resolve(Dictionary);
			
			assertTrue(instance is Dictionary);
		}
		
		public function test_register_should_register_instance():void
		{
			var factory:AsFactory = new AsFactory();
			var registeredInstance:Dictionary = new Dictionary();
			factory.register(registeredInstance, Dictionary);
			
			var instance:Dictionary = factory.resolve(Dictionary);
			
			assertSame(instance, registeredInstance);
		}
		
		public function test_register_should_register_callback():void
		{
			var factory:AsFactory = new AsFactory();
			var registeredInstance:Dictionary = new Dictionary();
			var callback:Function = function():Dictionary { return registeredInstance; };
			factory.register(callback, Dictionary);
			
			var instance:Dictionary = factory.resolve(Dictionary);
			
			assertSame(instance, registeredInstance);
		}
	}
}