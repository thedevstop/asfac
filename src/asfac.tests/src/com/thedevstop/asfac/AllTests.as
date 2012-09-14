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
			
			addTest(new SampleTests("isTrueTrue"));
		}
		
	}

}