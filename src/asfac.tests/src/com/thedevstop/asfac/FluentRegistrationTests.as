package com.thedevstop.asfac 
{
	import asunit.framework.TestCase;
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class FluentRegistrationTests extends TestCase
	{
		public function FluentRegistrationTests(testMethod:String = null) 
		{
			super(testMethod);
		}
		
		public function test_should_allow_register_concrete_instance():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var instance:Object = { foo:"bar" };
			factory.register(instance).asType(Object);
			
			var result:Object = factory.resolve(Object);
			assertSame(instance, result);
		}
		
		public function test_should_allow_register_type():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			factory.register(Dictionary).asType(Dictionary);
			
			var result:Object = factory.resolve(Dictionary);
			assertTrue(result.constructor == Dictionary);
		}
		
		public function test_should_allow_register_callback():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var source:Array = [1, 2, 3];
			factory.register(function():Array { return source; }).asType(Array);
			
			var result:Array = factory.resolve(Array);
			assertSame(source, result);			
		}
		
		public function test_should_error_when_registering_callback_with_arguments():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var registerFunc:Function = function():void
			{
				factory.register(function(name:String):Array { return [1, 2, 3]; }).asType(Array);
			};
			
			assertThrows(IllegalOperationError, registerFunc);
		}
		
		public function test_should_allow_register_callback_as_singleton():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			factory.register(function():Dictionary { return new Dictionary(); } ).asType(Dictionary).asSingleton();
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertSame(result1, result2);
		}
		
		public function test_should_allow_register_type_as_singleton():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			factory.register(Dictionary).asType(Dictionary).asSingleton();
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertSame(result1, result2);
		}
		
		public function test_should_retun_new_instances_when_not_registered_as_singleton():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			factory.register(Dictionary).asType(Dictionary);
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertNotSame(result1, result2);
		}
		
		public function test_callbacks_should_allow_register_type_as_singleton():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			factory.register(function():Dictionary { return new Dictionary(); } ).asType(Dictionary).asSingleton();
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertSame(result1, result2);
		}
		
		public function test_callbacks_should_retun_new_instances_when_not_registered_as_singleton():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			factory.register(function():Dictionary { return new Dictionary(); } ).asType(Dictionary);
			
			var result1:Object = factory.resolve(Dictionary);
			var result2:Object = factory.resolve(Dictionary);
			assertNotSame(result1, result2);
		}
		
		public function test_should_error_when_registering_type_is_null():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var registerFunc:Function = function():void
			{
				factory.register(Dictionary).asType(null);
			};
			
			assertThrows(IllegalOperationError, registerFunc);			
		}
	}
}