package com.thedevstop.asfac 
{
	import asunit.framework.TestCase;
	import com.thedevstop.asfac.stubs.ConstructorWithRequiredParameters;
	import com.thedevstop.asfac.stubs.HasObjectProperty;
	import com.thedevstop.asfac.stubs.IPoint;
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import mx.collections.ArrayCollection;
	
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
			
			factory.register(ConstructorWithRequiredParameters, ConstructorWithRequiredParameters);
			
			var result:Object = factory.resolve(ConstructorWithRequiredParameters);
			assertTrue(result.constructor === ConstructorWithRequiredParameters);
		}
		
		public function test_should_resolve_types_with_only_optional_constructor_parameters():void
		{
			var factory:AsFactory = new AsFactory();
			
			factory.register(Dictionary, Dictionary);
			
			var result:Object = factory.resolve(Dictionary);
			assertTrue(result is Dictionary);			
		}
		
		public function test_should_resolve_constructor_parameters_with_registered_instances():void
		{
			var factory:AsFactory = new AsFactory();
			
			var instance:Dictionary = new Dictionary();
			instance["foo"] = "bar";
			factory.register(instance, Dictionary);
			
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
			factory.register(obj, Object);
			
			var propertyObject:HasObjectProperty = factory.resolve(HasObjectProperty);
			
			assertSame(obj, propertyObject.theObject);					
		}
		
		public function test_should_resolve_type_from_unspecified_scope():void
		{
			var factory:AsFactory = new AsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.register(obj, Object, "nonDefaultScope");
			
			var instance:Object = factory.resolve(Object);
			assertNotNull(instance);
			assertNotSame(instance, obj);
		}
		
		public function test_should_resolve_type_with_specified_scope():void
		{
			var factory:AsFactory = new AsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.register(obj, Object, "nonDefaultScope");
			
			var instance:Object = factory.resolve(Object, "nonDefaultScope");
			assertSame(instance, obj);
		}
		
		public function test_should_resolve_type_with_class_scope():void
		{
			var factory:AsFactory = new AsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.register(obj, Object, HasObjectProperty);
			
			var instance:Object = factory.resolve(Object, HasObjectProperty);
			assertSame(instance, obj);
		}
		
		public function test_should_resolve_default_scope_if_registered():void
		{
			var factory:AsFactory = new AsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.register(obj, Object);
			
			var instance:Object = factory.resolve(Object);
			assertSame(instance, obj);
		}
		
		public function test_should_throw_error_when_resolving_with_scope_that_is_not_registered():void
		{
			var factory:AsFactory = new AsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.register(obj, Object);
			
			var resolveFunction:Function = function ():void 
			{
				var instance:Object = factory.resolve(Object, "nonDefaultScope");
			};
			
			assertThrows(ArgumentError, resolveFunction);
		}
		
		public function test_should_pass_factory_into_callback_during_resolution():void
		{
			var factory:AsFactory = new AsFactory();
			
			var scope:String = "nonDefaultScope";
			
			var resolveFunction:Function = function (asFactory:AsFactory, scopeName:String):Object 
			{
				assertSame(factory, asFactory);
				return new Dictionary();
			};
			factory.register(resolveFunction, Dictionary, scope);
			
			var instance:Dictionary = factory.resolve(Dictionary);		
		}
		
		public function test_should_pass_factory_and_scope_name_into_callback_during_resolution():void
		{
			var factory:AsFactory = new AsFactory();
			
			var foo:Object = { bar:"baz" };
			factory.register(foo, Object);
			
			factory.register(function (asFactory:AsFactory, scopeName:String):HasObjectProperty
			{
				var result:HasObjectProperty = new HasObjectProperty();
				result.theObject = factory.resolve(Object);
				return result;
			}, HasObjectProperty);
			
			var instance:HasObjectProperty = factory.resolve(HasObjectProperty);
			assertSame(foo, instance.theObject);
		}
		
		public function test_should_pass_scope_name_into_callback_during_resolution():void
		{
			var factory:AsFactory = new AsFactory();
			
			var scope:String = "nonDefaultScope";
			
			var resolveFunction:Function = function (factory:AsFactory, scopeName:String):Object 
			{
				assertEquals(scopeName, scope);
				return new Dictionary();
			};
			factory.register(resolveFunction, Dictionary, scope);
			
			var instance:Dictionary = factory.resolve(Dictionary);		
		}
		
		public function test_should_resolve_from_singleton_registration():void
		{
			var singletonDictionary:Dictionary = new Dictionary();
			AsFactoryLocator.factory.register(singletonDictionary, Dictionary);
			
			var factory:AsFactory = new AsFactory();
			var instanceDictionary:Dictionary = new Dictionary();
			factory.register(instanceDictionary, Dictionary);
			
			var instance:Dictionary = AsFactoryLocator.factory.resolve(Dictionary);
			
			assertSame(instance, singletonDictionary);
		}
		
		public function test_should_resolve_from_instance_registration():void
		{
			var singletonDictionary:Dictionary = new Dictionary();
			AsFactoryLocator.factory.register(singletonDictionary, Dictionary);
			
			var factory:AsFactory = new AsFactory();
			var instanceDictionary:Dictionary = new Dictionary();
			factory.register(instanceDictionary, Dictionary);
			
			var instance:Dictionary = factory.resolve(Dictionary);
			
			assertSame(instance, instanceDictionary);
		}
		
		public function test_should_resolve_from_class_instance_scope():void
		{
			var factory:AsFactory = new AsFactory();
			var obj:Object = { };

			factory.register(Dictionary, Dictionary, Object);
			var result:Object = factory.resolve(Dictionary, obj);

			assertTrue(result.constructor == Dictionary);
		}
		
		public function test_resolveAll_should_resolve_from_all_scopes():void
		{
			var factory:AsFactory = new AsFactory();
			var obj1:Object = { };
			var obj2:Object = { };
			
			factory.register(obj1, Object, "obj1");
			factory.register(obj2, Object, "obj2");
			
			var results:ArrayCollection = new ArrayCollection(factory.resolveAll(Object));
			
			assertTrue(results.contains(obj1));
			assertTrue(results.contains(obj2));
		}

		public function test_should_resolve_from_class_scope():void
		{
			var factory:AsFactory = new AsFactory();
			var obj:Object = { };

			factory.register(Dictionary, Dictionary, obj);
			var result:Object = factory.resolve(Dictionary, Object);

			assertTrue(result.constructor == Dictionary);
		}

		public function test_scoped_resolve_resolves_constructor_dependencies_from_scope():void
		{
			var factory:AsFactory = new AsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			var scopedDictionary:Dictionary = new Dictionary();
			
			factory.register(ConstructorWithRequiredParameters, Object, scopeName);
			factory.register(defaultDictionary, Dictionary);
			factory.register(scopedDictionary, Dictionary, scopeName);
			
			var instance:ConstructorWithRequiredParameters = factory.resolve(Object, scopeName);
			
			assertSame(instance.dictionary, scopedDictionary);
		}
		
		public function test_scoped_resolve_fallsback_to_defaultScope_for_constructor_dependencies():void
		{
			var factory:AsFactory = new AsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			
			factory.register(ConstructorWithRequiredParameters, Object, scopeName);
			factory.register(defaultDictionary, Dictionary);
			
			var instance:ConstructorWithRequiredParameters = factory.resolve(Object, scopeName);
			
			assertSame(instance.dictionary, defaultDictionary);
		}
		
		public function test_scoped_resolve_resolves_injected_properties_from_scope():void
		{
			var factory:AsFactory = new AsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			var scopedDictionary:Dictionary = new Dictionary();
			
			factory.register(HasObjectProperty, HasObjectProperty, scopeName);
			factory.register(defaultDictionary, Object);
			factory.register(scopedDictionary, Object, scopeName);
			
			var instance:HasObjectProperty = factory.resolve(HasObjectProperty, scopeName);
			
			assertSame(instance.theObject, scopedDictionary);
		}		
		
		public function test_scoped_resolve_fallsback_to_defaultScope_for_injected_properties():void
		{
			var factory:AsFactory = new AsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			
			factory.register(HasObjectProperty, HasObjectProperty, scopeName);
			factory.register(defaultDictionary, Object);
			
			var instance:HasObjectProperty = factory.resolve(HasObjectProperty, scopeName);
			
			assertSame(instance.theObject, defaultDictionary);
		}
		
		public function test_scoped_resolve_should_fallback_when_specified():void
		{
			var factory:AsFactory = new AsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			
			factory.register(defaultDictionary, Dictionary);
			
			var instance:Dictionary = factory.resolve(Dictionary, scopeName, true);
			
			assertSame(instance, defaultDictionary);			
		}
	}
}
