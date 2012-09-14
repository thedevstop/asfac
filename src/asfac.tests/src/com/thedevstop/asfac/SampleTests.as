package com.thedevstop.asfac 
{
	import asunit.framework.TestCase;
	/**
	 * ...
	 * @author David Ruttka
	 */
	public class SampleTests extends TestCase
	{
		
		public function SampleTests(testMethod:String) 
		{
			super(testMethod);
		}
		
		public function isTrueTrue():void
		{
			assertEquals(true, true);
		}
	}

}