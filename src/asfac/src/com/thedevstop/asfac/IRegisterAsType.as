package com.thedevstop.asfac 
{	
	/**
	 * ...
	 * @author 
	 */
	public interface IRegisterAsType
	{
		/**
		 * Continues the registration by specifying the type of dependency.
		 * @param	type The type of dependency this registration resolves.
		 * @return The ability to specify the resolution is a singleton.
		 */
		function asType(type:Class):IRegisterAsSingleton
	}
}