package com.thedevstop.asfac 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IRegisterInScope
	{
		function register(instance:*):IRegisterAsType
		function inScope(scopeName:String):IRegister
	}
}