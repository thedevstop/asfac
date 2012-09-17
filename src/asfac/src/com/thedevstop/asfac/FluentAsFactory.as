package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentAsFactory extends AsFactory implements IRegister
	{
		public function register(instance:*):IRegisterAs
		{
			return new RegisterAs(this, instance);
		}	
	}
}