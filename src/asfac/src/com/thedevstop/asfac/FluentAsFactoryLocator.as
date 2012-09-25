package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentAsFactoryLocator 
	{
		private static var _instance:FluentAsFactory = null;
		
		static public function get factory():FluentAsFactory
		{
			_instance = _instance || new FluentAsFactory(AsFactory.instance);
			return _instance;
		}
	}
}