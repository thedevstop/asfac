package com.thedevstop.asfac 
{
	import asunit.framework.TestCase;
	import asunit.framework.TestSuite;
	
	/**
	 * ...
	 * @author
	 */
	public class AllTests extends TestSuite
	{
		public function AllTests() 
		{
			super();
			
			addTest(new RegistrationTests());
			addTest(new ResolutionTests());
			addTest(new FluentRegistrationTests());
		}
	}
}