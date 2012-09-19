package com.thedevstop.asfac.stubs 
{
	/**
	 * ...
	 * @author David Ruttka
	 */
	public class HasObjectProperty 
	{
		private var _theObject:Object;
		
		public function HasObjectProperty() 
		{
			
		}

		public function get theObject():Object
		{
			return _theObject;
		}
		
		public function set theObject(rhs:Object):void
		{
			_theObject = rhs;
		}
	}

}