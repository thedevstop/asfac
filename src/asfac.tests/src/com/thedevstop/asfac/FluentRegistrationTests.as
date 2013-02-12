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
		
		public function test_should_error_when_registering_callback_with_too_many_arguments():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var registerFunc:Function = function():void
			{
				factory.register(function(asFactory:AsFactory, name:String, num:Number):Array { return [1, 2, 3]; }).asType(Array);
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
		
		public function test_registered_callbacks_can_accept_factory_and_scope_name_as_parameters():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var foo:Object = { bar:"baz" };
			factory.register(foo).asType(Object);
			
			factory.register(function (asFactory:AsFactory, scopeName:String):HasObjectProperty
			{
				var result:HasObjectProperty = new HasObjectProperty();
				result.theObject = factory.resolve(Object);
				return result;
			}).asType(HasObjectProperty);
			
			var instance:HasObjectProperty = factory.resolve(HasObjectProperty);
			assertSame(foo, instance.theObject);
		}
		
		public function test_fluentasfactorylocator_should_register_with_asfactory_from_asfactorylocator():void
		{
			var singletonDictionary:Dictionary = new Dictionary();
			FluentAsFactoryLocator.factory.register(singletonDictionary).asType(Dictionary);
			
			var instance:Dictionary = AsFactoryLocator.factory.resolve(Dictionary);
			
			assertSame(instance, singletonDictionary);	
		}
		
		public function test_should_be_able_to_use_class_as_registration_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();

			factory.inScope(Object).register(Dictionary).asType(Dictionary);
			var result:Object = factory.fromScope(Object).resolve(Dictionary);

			assertTrue(result.constructor == Dictionary);
		}

		public function test_should_be_able_to_use_class_instance_as_registration_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var obj:Object = { };

			factory.inScope(obj).register(Dictionary).asType(Dictionary);
			var result:Object = factory.fromScope(obj).resolve(Dictionary);

			assertTrue(result.constructor == Dictionary);
		}
	}
}