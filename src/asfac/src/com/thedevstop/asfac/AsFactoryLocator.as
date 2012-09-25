package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class AsFactoryLocator
	{
		private static var _instance:AsFactory = null;
		
		static public function get factory():AsFactory
		{
			_instance = _instance || new AsFactory();
			return _instance;
		}
	}
}