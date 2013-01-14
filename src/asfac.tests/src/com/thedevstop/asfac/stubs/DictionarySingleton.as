package com.thedevstop.asfac.stubs 
{
	import flash.utils.Dictionary;
	// Note: we don't truly enforce the singleton pattern on this fake. We only allow there to be an singleton instance for tests
	public class DictionarySingleton 
	{
		private static var _instance:Dictionary;
		
		public function DictionarySingleton() 
		{
			
		}
		
		public static function get instance():Dictionary
		{
			if (!_instance)
				_instance = new Dictionary();
			
			return _instance;
		}
	}
}