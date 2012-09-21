package com.thedevstop.asfac 
{
	import asunit.framework.TestCase;
	import com.thedevstop.asfac.stubs.ConstructorWithRequiredParameters;
	import com.thedevstop.asfac.stubs.HasObjectProperty;
	import com.thedevstop.asfac.stubs.IPoint;
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResolutionTests extends TestCase
	{	
		public function ResolutionTests(testMethod:String = null) 
		{
			super(testMethod);
		}
		
		public function test_should_resolve_unregistered_types():void
		{
			var factory:AsFactory = new AsFactory();
			
			var result:Object = factory.resolve(Dictionary);
			assertTrue(result is Dictionary);
		}
		
		public function test_should_resolve_types_with_required_constructor_parameters():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerType(ConstructorWithRequiredParameters, ConstructorWithRequiredParameters);
			
			var result:Object = factory.resolve(ConstructorWithRequiredParameters);
			assertTrue(result.constructor === ConstructorWithRequiredParameters);
		}
		
		public function test_should_resolve_types_with_only_optional_constructor_parameters():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.registerType(Dictionary, Dictionary);
			
			var result:Object = factory.resolve(Dictionary);
			assertTrue(result is Dictionary);			
		}
		
		public function test_should_resolve_constructor_parameters_with_registered_instances():void
		{
			var factory:AsFactory = new AsFactory();
			
			var instance:Dictionary = new Dictionary();
			instance["foo"] = "bar";
			factory.registerInstance(instance, Dictionary);
			
			var result:ConstructorWithRequiredParameters = factory.resolve(ConstructorWithRequiredParameters);
			assertSame(instance, result.dictionary);
		}
		
		public function test_should_error_when_resolving_unregistered_interface():void
		{
			var factory:AsFactory = new AsFactory();
			
			var resolveFunc:Function = function():void
			{
				factory.resolve(IPoint);
			};
			
			assertThrows(IllegalOperationError, resolveFunc);
		}
		
		public function test_should_error_when_resolving_type_is_null():void
		{
			var factory:AsFactory = new AsFactory();
			
			var resolveFunc:Function = function():void
			{
				factory.resolve(null);
			};
			
			assertThrows(IllegalOperationError, resolveFunc);					
		}
		
		public function test_should_resolve_properties_marked_with_inject_metadata():void
		{
			var factory:AsFactory = new AsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.registerInstance(obj, Object);
			
			var propertyObject:HasObjectProperty = factory.resolve(HasObjectProperty);
			
			assertSame(obj, propertyObject.theObject);					
		}
		
		public function test_should_resolve_type_from_unspecified_scope():void
		{
			var factory:AsFactory = new AsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.registerInstance(obj, Object, "nonDefaultScope");
			
			var instance:Object = factory.resolve(Object);
			assertNotNull(instance);
			assertNotSame(instance, obj);
		}
		
		public function test_should_resolve_type_with_specified_scope():void
		{
			var factory:AsFactory = new AsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.registerInstance(obj, Object, "nonDefaultScope");
			
			var instance:Object = factory.resolve(Object, "nonDefaultScope");
			assertSame(instance, obj);
		}
		
		public function test_should_resolve_default_scope_if_registered():void
		{
			var factory:AsFactory = new AsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.registerInstance(obj, Object);
			
			var instance:Object = factory.resolve(Object);
			assertSame(instance, obj);
		}
	}
}