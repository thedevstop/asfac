package com.thedevstop.asfac 
{
	import adobe.utils.CustomActions;
	import asunit.framework.TestCase;
	import asunit.framework.TestSuite;
	import com.thedevstop.asfac.stubs.ConstructorWithRequiredParameters;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author David Ruttka
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
		 * register a type as a type, so that a new instance of that type is returned whenever requested
		 * register a callback as a type, so that the result of the callback is returned whenever requested
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
			assertTrue(result.constructor === Dictionary);
		}
		
		public function test_should_resolve_types_with_required_constructor_parameters():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerType(ConstructorWithRequiredParameters, ConstructorWithRequiredParameters);
			
			var result:Object = factory.resolve(ConstructorWithRequiredParameters);
			assertTrue(result.constructor === ConstructorWithRequiredParameters);
		}
		
		public function test_should_attempt_to_resolve_unregistered_types():void
		{
			var factory:AsFactory = new AsFactory();
			
			var result:Object = factory.resolve(Dictionary);
			assertTrue(result is Dictionary);
		}
		
		public function test_should_resolve_types_with_only_optional_constructor_parameters():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerType(Dictionary, Dictionary);
			
			var result:Object = factory.resolve(Dictionary);
			assertTrue(result is Dictionary);			
		}
		
		public function test_should_allow_register_callback():void
		{
			var factory:AsFactory = new AsFactory();
			
			var source:Array = [1, 2, 3];
			factory.registerCallback(function():Array { return source; }, Array);
			
			var result:Array = factory.resolve(Array);
			assertSame(source, result);			
		}
		
		public function test_resolving_constructor_params_should_use_registered_instances():void
		{
			var factory:AsFactory = new AsFactory();
			
			var instance:Dictionary = new Dictionary();
			instance["foo"] = "bar";
			factory.registerInstance(instance, Dictionary);
			
			var result:ConstructorWithRequiredParameters = factory.resolve(ConstructorWithRequiredParameters);
			assertSame(instance, result.dictionary);
		}
	}
}