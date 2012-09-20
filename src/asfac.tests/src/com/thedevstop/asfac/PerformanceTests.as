package com.thedevstop.asfac 
{
	import asunit.framework.TestCase;
	import com.thedevstop.asfac.stubs.DictionarySingleton;
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
		
		public function test_should_resolve_types_within_tolerance_of_manual_resolution_duration():void
		{
			const NumberOfResolutions:Number = 100000;
			// TODO: Pull the competition and adjust this target accordingly
			const AllowableTolerance:Number = 5.00;
			
			var factory:AsFactory = new AsFactory();
			var resolutions:Number = 0;
			var instance:Dictionary;
			
			var manualStartTime:Number = new Date().getTime();
			
			while(resolutions < NumberOfResolutions)
			{
				instance = new Dictionary();
				resolutions++;
			}
			
			var manualDuration:Number = new Date().getTime() - manualStartTime;
			
			resolutions = 0;
			var asFacStartTime:Number = new Date().getTime();
			
			while(resolutions < NumberOfResolutions)
			{
				instance = factory.resolve(Dictionary);
				resolutions++;
			}
			
			var asFacDuration:Number = new Date().getTime() - asFacStartTime;
			
			var toleratedDuration:Number = manualDuration * AllowableTolerance;
			var whatWouldHaveBeenOk:Number = asFacDuration / manualDuration;
			assertTrue(asFacDuration < toleratedDuration);
		}
		
		public function test_should_resolve_singletons_within_tolerance_of_manual_resolution_duration():void
		{
			const NumberOfResolutions:Number = 100000;
			// TODO: Pull the competition and adjust this target accordingly
			const AllowableTolerance:Number = 2.5;
			
			var factory:AsFactory = new AsFactory();
			factory.registerType(Dictionary, Dictionary, true);
			
			var resolutions:Number = 0;
			var instance:Dictionary;
			
			var manualStartTime:Number = new Date().getTime();
			
			while(resolutions < NumberOfResolutions)
			{
				instance = DictionarySingleton.instance;
				resolutions++;
			}
			
			var manualDuration:Number = new Date().getTime() - manualStartTime;
			
			resolutions = 0;
			var asFacStartTime:Number = new Date().getTime();
			
			while(resolutions < NumberOfResolutions)
			{
				instance = factory.resolve(Dictionary);
				resolutions++;
			}
			
			var asFacDuration:Number = new Date().getTime() - asFacStartTime;
			
			var toleratedDuration:Number = manualDuration * AllowableTolerance;
			var whatWouldHaveBeenOk:Number = asFacDuration / manualDuration;
			assertTrue(asFacDuration < toleratedDuration);
		}
		
	}

}