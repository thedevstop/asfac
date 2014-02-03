package com.thedevstop.asfac 
{
	import adobe.utils.CustomActions;
	import asunit.framework.TestCase;
	import com.thedevstop.asfac.stubs.ConstructorWithRequiredParameters;
	import com.thedevstop.asfac.stubs.HasObjectProperty;
	import com.thedevstop.asfac.stubs.IPoint;
	import flash.display.AVM1Movie;
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import mx.collections.ArrayCollection;
	
	/**
	 * ...
	 * @author 
	 */
	public class FluentResolutionTests  extends TestCase
	{	
		public function FluentResolutionTests(testMethod:String = null) 
		{
			super(testMethod);
		}
		
		public function test_should_resolve_unregistered_types():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var result:Object = factory.resolve(Dictionary);
			assertTrue(result is Dictionary);
		}
		
		public function test_should_resolve_types_with_required_constructor_parameters():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			factory.register(ConstructorWithRequiredParameters).asType(ConstructorWithRequiredParameters);
			
			var result:Object = factory.resolve(ConstructorWithRequiredParameters);
			assertTrue(result.constructor === ConstructorWithRequiredParameters);
		}
		
		public function test_should_resolve_types_with_only_optional_constructor_parameters():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			factory.register(Dictionary).asType(Dictionary);
			
			var result:Object = factory.resolve(Dictionary);
			assertTrue(result is Dictionary);			
		}
		
		public function test_should_resolve_constructor_parameters_with_registered_instances():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var instance:Dictionary = new Dictionary();
			instance["foo"] = "bar";
			factory.register(instance).asType(Dictionary);
			
			var result:ConstructorWithRequiredParameters = factory.resolve(ConstructorWithRequiredParameters);
			assertSame(instance, result.dictionary);
		}
		
		public function test_should_error_when_resolving_unregistered_interface():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var resolveFunc:Function = function():void
			{
				factory.resolve(IPoint);
			};
			
			assertThrows(IllegalOperationError, resolveFunc);
		}
		
		public function test_should_error_when_resolving_type_is_null():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var resolveFunc:Function = function():void
			{
				factory.resolve(null);
			};
			
			assertThrows(IllegalOperationError, resolveFunc);					
		}
		
		public function test_should_resolve_properties_marked_with_inject_metadata():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.register(obj).asType(Object);
			
			var propertyObject:HasObjectProperty = factory.resolve(HasObjectProperty);
			
			assertSame(obj, propertyObject.theObject);					
		}
		
		public function test_should_resolve_type_from_unspecified_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.inScope("nonDefaultScope").register(obj).asType(Object);
			
			var instance:Object = factory.resolve(Object);
			assertNotNull(instance);
			assertNotSame(instance, obj);
		}
		
		public function test_should_resolve_type_with_specified_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.inScope("nonDefaultScope").register(obj).asType(Object);
			
			var instance:Object = factory.fromScope("nonDefaultScope").resolve(Object);
			assertSame(instance, obj);
		}
		
		public function test_should_resolve_default_scope_if_registered():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.register(obj).asType(Object);
			
			var instance:Object = factory.resolve(Object);
			assertSame(instance, obj);
		}
		
		public function test_should_throw_error_when_resolving_with_scope_that_is_not_registered():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var obj:Object = { numbers:[1, 2, 3] };
			factory.register(obj).asType(Object);
			
			var resolveFunction:Function = function ():void 
			{
				var instance:Object = factory.fromScope("nonDefaultScope").resolve(Object);
			};
			
			assertThrows(ArgumentError, resolveFunction);
		}
		
		public function test_should_pass_factory_into_callback_during_resolution():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var scope:String = "nonDefaultScope";
			
			var resolveFunction:Function = function (asFactory:AsFactory, scopeName:String):Object 
			{
				assertSame(factory, asFactory);
				return new Dictionary();
			};
			factory.inScope(scope).register(resolveFunction).asType(Dictionary);
			
			var instance:Dictionary = factory.resolve(Dictionary);		
		}
		
		public function test_should_pass_factory_and_scope_name_into_callback_during_resolution():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var foo:Object = { bar:"baz" };
			factory.register(foo).asType(Object);
			
			var callback:Function = function (asFactory:AsFactory, scopeName:String):HasObjectProperty
			{
				var result:HasObjectProperty = new HasObjectProperty();
				result.theObject = factory.resolve(Object);
				return result;
			};			
			factory.register(callback).asType(HasObjectProperty);
			
			var instance:HasObjectProperty = factory.resolve(HasObjectProperty);
			assertSame(foo, instance.theObject);
		}
		
		public function test_should_pass_scope_name_into_callback_during_resolution():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			
			var scope:String = "nonDefaultScope";
			
			var resolveFunction:Function = function (factory:AsFactory, scopeName:String):Object 
			{
				assertEquals(scopeName, scope);
				return new Dictionary();
			};
			factory.inScope(scope).register(resolveFunction).asType(Dictionary);
			
			var instance:Dictionary = factory.resolve(Dictionary);		
		}
		
		public function test_should_resolve_from_singleton_registration():void
		{
			var singletonDictionary:Dictionary = new Dictionary();
			FluentAsFactoryLocator.factory.register(singletonDictionary).asType(Dictionary);
			
			var factory:FluentAsFactory = new FluentAsFactory();
			var instanceDictionary:Dictionary = new Dictionary();
			factory.register(instanceDictionary).asType(Dictionary);
			
			var instance:Dictionary = FluentAsFactoryLocator.factory.resolve(Dictionary);
			
			assertSame(instance, singletonDictionary);
		}
		
		public function test_should_resolve_from_instance_registration():void
		{
			var singletonDictionary:Dictionary = new Dictionary();
			FluentAsFactoryLocator.factory.register(singletonDictionary).asType(Dictionary);
			
			var factory:FluentAsFactory = new FluentAsFactory();
			var instanceDictionary:Dictionary = new Dictionary();
			factory.register(instanceDictionary).asType(Dictionary);
			
			var instance:Dictionary = factory.resolve(Dictionary);
			
			assertSame(instance, instanceDictionary);
		}
		
		public function test_fluentasfactorylocator_should_resolve_with_asfactory_from_asfactorylocator():void
		{
			var singletonDictionary:Dictionary = new Dictionary();
			AsFactoryLocator.factory.register(singletonDictionary, Dictionary);
			
			var instance:Dictionary = FluentAsFactoryLocator.factory.resolve(Dictionary);
			
			assertSame(instance, singletonDictionary);	
		}
		
		public function test_should_resolve_from_class_instance_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var obj:Object = { };

			factory.inScope(Object).register(Dictionary).asType(Dictionary);
			var result:Object = factory.fromScope(obj).resolve(Dictionary);

			assertTrue(result.constructor == Dictionary);
		}

		public function test_should_resolve_from_class_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var obj:Object = { };

			factory.inScope(obj).register(Dictionary).asType(Dictionary);
			var result:Object = factory.fromScope(Object).resolve(Dictionary);

			assertTrue(result.constructor == Dictionary);
		}
		
		public function test_resolveAll_should_resolve_from_all_scopes():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var obj1:Object = { };
			var obj2:Object = { };
			
			factory.inScope("obj1").register(obj1).asType(Object);
			factory.inScope("obj2").register(obj2).asType(Object);
			
			var results:ArrayCollection = new ArrayCollection(factory.resolveAll(Object));
			
			assertTrue(results.contains(obj1));
			assertTrue(results.contains(obj2));
		}
		
		public function test_scoped_resolve_resolves_constructor_dependencies_from_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			var scopedDictionary:Dictionary = new Dictionary();
			
			factory.register(defaultDictionary).asType(Dictionary);
			factory.inScope(scopeName).register(scopedDictionary).asType(Dictionary);
			factory.inScope(scopeName).register(ConstructorWithRequiredParameters).asType(Object);
			
			var instance:ConstructorWithRequiredParameters = factory.fromScope(scopeName).resolve(Object);
			
			assertSame(instance.dictionary, scopedDictionary);
		}
		
		public function test_scoped_resolve_fallsback_to_defaultScope_for_constructor_dependencies():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			
			factory.register(defaultDictionary).asType(Dictionary);
			factory.inScope(scopeName).register(ConstructorWithRequiredParameters).asType(Object);
			
			var instance:ConstructorWithRequiredParameters = factory.fromScope(scopeName).resolve(Object);
			
			assertSame(instance.dictionary, defaultDictionary);
		}
		
		public function test_scoped_resolve_resolves_injected_properties_from_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			var scopedDictionary:Dictionary = new Dictionary();
			
			factory.register(defaultDictionary).asType(Object);
			factory.inScope(scopeName).register(scopedDictionary).asType(Object);
			factory.inScope(scopeName).register(HasObjectProperty).asType(HasObjectProperty);
			
			var instance:HasObjectProperty = factory.fromScope(scopeName).resolve(HasObjectProperty);
			
			assertSame(instance.theObject, scopedDictionary);
		}		
		
		public function test_scoped_resolve_fallsback_to_defaultScope_for_injected_properties():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			
			factory.register(defaultDictionary).asType(Object);
			factory.inScope(scopeName).register(HasObjectProperty).asType(HasObjectProperty);
			
			var instance:HasObjectProperty = factory.fromScope(scopeName).resolve(HasObjectProperty);
			
			assertSame(instance.theObject, defaultDictionary);
		}
		public function test_unscoped_resolve_uses_default_scope_after_scoped_resolve():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var defaultItem:Object = { };
			var scopedItem:Object = new Dictionary();
			var scopeName:String = "nonDefaultScope";
			
			factory.inScope(scopeName).register(scopedItem).asType(Object);
			factory.register(defaultItem).asType(Object);
			var ignore:Object = factory.fromScope(scopeName).resolve(Object);
			var instance:Object = factory.resolve(Object);
			
			assertSame(defaultItem, instance);
		}
		
		public function test_scoped_resolver_resolves_from_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var object:Object = { };
			var dictionary:Dictionary = new Dictionary();
			var scopeName:String = "nonDefaultScope";
			
			factory.inScope(scopeName).register(object).asType(Object);
			factory.inScope(scopeName).register(dictionary).asType(Dictionary);
			
			var scopedResolver:IResolve = factory.fromScope(scopeName);
			var objectInstance:Object = scopedResolver.resolve(Object);
			var dictionaryInstance:Dictionary = scopedResolver.resolve(Dictionary);
			
			assertSame(objectInstance, object);
			assertSame(dictionaryInstance, dictionary);
		}
		
		public function test_scoped_resolver_continues_resolving_from_scope():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var object:Object = { };
			var dictionary:Dictionary = new Dictionary();
			var scopeName:String = "nonDefaultScope";
			var anotherScopeName:String = "anotherNonDefaultScope";
			
			factory.inScope(scopeName).register(object).asType(Object);
			factory.inScope(scopeName).register(dictionary).asType(Dictionary);
			
			var scopedResolver:IResolve = factory.fromScope(scopeName);
			var objectInstance:Object = scopedResolver.resolve(Object);
			var anotherScopedResolver:IResolve = factory.fromScope(anotherScopeName);
			var dictionaryInstance:Dictionary = scopedResolver.resolve(Dictionary);
			
			assertSame(objectInstance, object);
			assertSame(dictionaryInstance, dictionary);
		}
		
		public function test_scoped_resolve_should_fallback_when_specified():void
		{
			var factory:FluentAsFactory = new FluentAsFactory();
			var scopeName:String = "nonDefaultScope";
			var defaultDictionary:Dictionary = new Dictionary();
			
			factory.register(defaultDictionary).asType(Dictionary);
			
			var instance:Dictionary = factory.fromScope(scopeName).resolveWithFallback(Dictionary);
			
			assertSame(instance, defaultDictionary);			
		}
	}
}
