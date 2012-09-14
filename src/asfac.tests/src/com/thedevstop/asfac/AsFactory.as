package com.thedevstop.asfac
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author David Ruttka
	 */
	public class AsFactory
	{
		private var _registrations:Dictionary;
		
		public function AsFactory()
		{
			_registrations = new Dictionary();
		}
		
		public function Register(instance:Object, type:Class):void
		{
			_registrations[type] = function():Object
			{
				return instance;
			};
		}
		
		public function Resolve(type:Class):*
		{
			return _registrations[type]();
		}
	}

}