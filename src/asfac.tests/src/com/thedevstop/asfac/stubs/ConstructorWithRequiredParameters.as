package com.thedevstop.asfac.stubs 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author David Ruttka
	 */
	public class ConstructorWithRequiredParameters 
	{
		private var _dictionary:Dictionary;
		
		public function ConstructorWithRequiredParameters(dictionary:Dictionary) 
		{
			this._dictionary = dictionary;
		}
		
		public function get dictionary():Dictionary
		{
			return _dictionary;
		}
		
	}

}