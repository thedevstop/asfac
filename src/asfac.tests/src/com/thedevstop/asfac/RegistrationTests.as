package com.thedevstop.asfac 
{
	import adobe.utils.CustomActions;
	import asunit.framework.TestCase;
	import asunit.framework.TestSuite;
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
			var container:AsFactory = new AsFactory();
			
			var instance:Object = { foo:"bar" };
			container.Register(instance, Object);
			
			var result:Object = container.Resolve(Object);
			assertSame(instance, result);
		}
		
		public function test_should_allow_register_type():void
		{
			var container:AsFactory = new AsFactory();
			
			container.Register(Dictionary, Dictionary);
			
			var result:Object = container.Resolve(Dictionary);
			assertTrue(result.constructor == Dictionary);
		}
	}
}