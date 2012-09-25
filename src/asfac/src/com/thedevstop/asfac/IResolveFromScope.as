package com.thedevstop.asfac 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IResolveFromScope 
	{
		function fromScope(scopeName:String):IResolve
		function resolve(type:Class):*
	}
	
}