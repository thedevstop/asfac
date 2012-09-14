package com.thedevstop.asfac 
{
	import asunit.framework.TestSuite;
	/**
	 * ...
	 * @author David Ruttka
	 */
	public class AllTests extends TestSuite
	{
		
		public function AllTests() 
		{
			super();
			
			var rt:RegistrationTests = new RegistrationTests();
			for each(var testName:String in rt.getTestMethods())
			{
				addTest(new RegistrationTests(testName));
			}
		}
	}
}