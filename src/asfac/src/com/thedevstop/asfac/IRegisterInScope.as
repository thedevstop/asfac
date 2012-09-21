package com.thedevstop.asfac 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IRegisterInScope
	{
		function inScope(scopeName:String):IRegisterAsSingleton
		function asSingleton():IRegisterCommit
		function commit():void;
	}
	
}