package com.thedevstop.asfac
{
	import avmplus.getQualifiedClassName;
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * The default AsFactory allows for registering instances, types, or callbacks
	 */
	public class AsFactory
	{
		private var _registrations:Dictionary;
		private var _descriptions:Dictionary;
		
		/**
		 * Constructs a new AsFactory
		 */
		public function AsFactory()
		{
			_registrations = new Dictionary();
			_descriptions = new Dictionary();
		}
		
		/**
		 * Registers a concrete instance to be returned whenever the target type is requested
		 * @param	instance the concrete instance to be returned
		 * @param	type the target type for which the instance should be returned at resolution time
		 */
		public function registerInstance(instance:Object, type:Class):void
		{
			var returnInstance:Function = function():Object
			{
				return instance;
			};
			
			registerCallback(returnInstance, type, false);
		}
		
		/**
		 * Registers a type to be returned whenever the target type is requested
		 * @param	instanceType the type to construct at resolution time
		 * @param	type the type being requested
		 * @param	asSingleton If true, only one instance will be created and returned on each request. If false (default), a new instance
		 * is created and returned at each resolution request
		 */
		public function registerType(instanceType:Class, type:Class, asSingleton:Boolean=false):void 
		{
			if (!instanceType)
				throw new IllegalOperationError("InstanceType cannot be null when registering a type");
			
			var resolveType:Function = function():Object
			{
				return resolveByClass(instanceType);
			};
			
			registerCallback(resolveType, type, asSingleton);
		}
		
		/**
		 * Registers a callback to be executed, the result of which is returned whenever the target type is requested
		 * @param	callback the callback to execute
		 * @param	type the type being requested
		 * @param	asSingleton If true, callback is only invoked once and the result is returned on each request. If false (default), 
		 * callback is invoked on each resolution request
		 */
		public function registerCallback(callback:Function, type:Class, asSingleton:Boolean=false):void 
		{
			if (!type)
				throw new IllegalOperationError("Type cannot be null when registering a callback");
				
			validateCallback(callback);
			
			if (asSingleton)
				_registrations[type] = (function(callback:Function):Function
				{
					var instance:Object = null;
					
					return function():Object
					{
						if (!instance)
							instance = callback(this);
						
						return instance;
					};
				})(callback);
			else
				_registrations[type] = callback;
		}
		
		/**
		 * Returns an instance for the target type, using prior registrations to fulfill constructor parameters
		 * @param	type the type being requested
		 * @return resolved instance
		 */
		public function resolve(type:Class):*
		{
			if (_registrations[type] !== undefined)
				return _registrations[type](this);
				
			return resolveByClass(type);
		}
		
		/**
		 * Resolves the desired type using prior registrations
		 * @param	type the type being requested
		 * @return the resolved instance
		 */
		private function resolveByClass(type:Class):*
		{
			if (!type)
				throw new IllegalOperationError("Type cannot be null when resolving.");
			
			var typeDescription:Object = getTypeDescription(type);
			
			if (!typeDescription)
				throw new IllegalOperationError("Interface must be registered before it can be resolved.");
			
			var parameters:Array = resolveConstructorParameters(typeDescription);
			var instance:Object = createObject(type, parameters);
			injectProperties(instance, typeDescription);
			
			return instance;
		}
		
		/**
		 * Creates a new instance of the type, using the specified parameters as the constructor parameters
		 * @param	type the type being created
		 * @param	parameters the parameters to supply to the constructor
		 * @return new instance of type
		 */
		private function createObject(type:Class, parameters:Array):*
		{
			switch (parameters.length)
			{
				case 0 : return new type();
				case 1 : return new type(parameters[0]);
				case 2 : return new type(parameters[0], parameters[1]);
				case 3 : return new type(parameters[0], parameters[1], parameters[2]);
				case 4 : return new type(parameters[0], parameters[1], parameters[2], parameters[3]);
				case 5 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]);
				case 6 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]);
				case 7 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
				case 8 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
				case 9 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8]);
				case 10 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9]);
				case 11 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10]);
				case 12 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11]);
				case 13 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12]);
				case 14 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13]);
				case 15 : return new type(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14]);
				default : throw new Error("Too many constructor parameters for createObject");
			}
		}
		
		/**
		 * Confirms that a callback is valid for registration. Currently the callback must accept no arguments, or a single AsFactory argument
		 * @param	callback the callback being tested
		 */
		private function validateCallback(callback:Function):void
		{
			if (callback == null)
				throw new IllegalOperationError("Callback cannot be null when registering a type");
			
			// TODO: How to check type?
			if (callback.length > 1)
				throw new IllegalOperationError("Callback function must have no arguments or a single AsFactory argument");
		}
		
		/**
		 * Gets the class description for the type
		 * @param	type The class to be described
		 * @return An object of constructor types and injectable properties
		 */
		private function getTypeDescription(type:Class):Object
		{
			if (_descriptions[type] !== undefined)
				return _descriptions[type];
			
			return _descriptions[type] = buildTypeDescription(type);
		}
		
		/**
		 * Builds an optimized description of the type.
		 * @param	type The type to be described.
		 * @return An optimized description of the constructor and injectable properties
		 */
		private function buildTypeDescription(type:Class):Object
		{
			var typeDescription:Object = { constructorTypes:[], injectableProperties:[] };
			var description:XML = describeType(type);
			
			if (description.factory.extendsClass.length() === 0)
				return null;
				
			for each (var parameter:XML in description.factory.constructor.parameter)
			{
				if (parameter.@optional.toString() != "false")
					break;
				
				var parameterType:Class = Class(getDefinitionByName(parameter.@type.toString()));
				typeDescription.constructorTypes.push(parameterType);
			}
			
			for each (var accessor:XML in description.factory.accessor)
			{
				if (shouldInjectAccessor(accessor))
				{
					var propertyType:Class = Class(getDefinitionByName(accessor.@type.toString()));
					typeDescription.injectableProperties.push( { name:accessor.@name.toString(), type:propertyType } ); 
				}
			}
			
			return typeDescription;
		}
		
		/**
		 * Determines whether the accessor should be injected 
		 * @param	accessor An accessor node from a class description xml
		 * @return true is the Inject metadata is present, otherwise false
		 */
		private function shouldInjectAccessor(accessor:XML):Boolean
		{				
			if (accessor.@access == "readwrite" ||
				accessor.@access == "write")
			{
				for each (var metadata:XML in accessor.metadata)
				{
					if (metadata.@name.toString() == "Inject")
						return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Resolves the non-optional parameters for a constructor
		 * @param	typeDescription The optimized description of the type
		 * @return An array of objects to use as constructor arguments
		 */
		private function resolveConstructorParameters(typeDescription:Object):Array
		{
			var parameters:Array = [];
			
			for each (var parameterType:Class in typeDescription.constructorTypes)
				parameters.push(resolve(parameterType));
			
			return parameters;
		}
		
		/**
		 * Resolves the properties on the instance object that are marked 'Inject'
		 * @param	instance The object to be inspected
		 * @param	typeDescription The optimized description of the type
		 */
		private function injectProperties(instance:Object, typeDescription:Object):void
		{
			for each (var injectableProperty:Object in typeDescription.injectableProperties)
			{
				instance[injectableProperty.name] = resolve(injectableProperty.type);
			}
		}
	}
}