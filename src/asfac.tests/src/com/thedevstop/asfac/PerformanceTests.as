package com.thedevstop.asfac 
{
	import asunit.framework.TestCase;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class PerformanceTests extends TestCase
	{
		
		public function PerformanceTests(testMethod:String = null) 
		{
			super(testMethod);
		}
		
		public function test_should_resolve_ten_thousand_types_in_100ms():void
		{
			var factory:AsFactory = new AsFactory();
			
			var resolutions:int = 0;
			var startTime:Number = new Date().getTime();
			
			while (resolutions < 10000)
			{
				var dictionary:Dictionary = factory.resolve(Dictionary);
				resolutions++;
			}
			
			var duration:Number = new Date().getTime() - startTime;
			
			assertTrue(duration < 100);
		}
		
		public function test_should_resolve_one_hundred_thousand_singleton_types_in_100ms():void
		{
			var factory:AsFactory = new AsFactory();
			factory.registerType(Dictionary, Dictionary, true);
			
			var resolutions:int = 0;
			var startTime:Number = new Date().getTime();
			
			while (resolutions < 100000)
			{
				var dictionary:Dictionary = factory.resolve(Dictionary);
				resolutions++;
			}
			
			var duration:Number = new Date().getTime() - startTime;
			
			assertTrue(duration < 100);
		}
		
	}

}