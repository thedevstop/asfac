package com.thedevstop.asfac
{
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author
	 */
	public class AsFactory
	{
		private var _registrations:Dictionary;
		
		public function AsFactory()
		{
			_registrations = new Dictionary();
		}
		
		public function registerInstance(instance:Object, type:Class):void
		{
			_registrations[type] = function():Object
			{
				return instance;
			};
		}
		
		public function registerType(instanceType:Class, type:Class):void 
		{
			_registrations[type] = function():Object
			{
				return resolveByClass(instanceType);
			};
		}
		
		public function resolve(type:Class):*
		{
			if (_registrations[type] !== undefined)
				return _registrations[type]();
				
			return resolveByClass(type);
		}
		
		public function registerCallback(callback:Function, type:Class):void 
		{
			_registrations[type] = callback;
		}
		
		private function resolveByClass(type:Class):*
		{
			var parameters:Array = [];
			var description:XML = describeType(type);
			var constructor:XMLList = description.factory.constructor;
			
			if (constructor.length() === 0)
				throw new IllegalOperationError("Interface {0} must be registered before it can be resolved.".replace("{0}", description.@name.toString()));
			
			for each (var parameter:XML in constructor.parameter)
			{
				if (parameter.@optional.toString() != "false")
					break;
				
				var parameterType:Class = Class(getDefinitionByName(parameter.@type.toString()));
				parameters.push(resolve(parameterType));
			}
			return createObject(type, parameters);
		}

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
	}
}