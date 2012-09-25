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
			
			var manualAction:Function = function():void 
			{ 
				var instance:Dictionary = new Dictionary();
			};
			var manualDuration:Number = Timer.timeAction(manualAction, NumberOfResolutions);
			
			var asfacAction:Function = function():void
			{
				var instance:Dictionary = factory.resolve(Dictionary); 
			}
			var asFacDuration:Number = Timer.timeAction(asfacAction, NumberOfResolutions);
			
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
			factory.registerType(Dictionary, Dictionary, AsFactory.DefaultScopeName, true);
			
			var manualAction:Function = function():void 
			{ 
				var instance:Dictionary = DictionarySingleton.instance; 
			};
			var manualDuration:Number = Timer.timeAction(manualAction, NumberOfResolutions);
			
			var asfacAction:Function = function():void
			{
				var instance:Dictionary = factory.resolve(Dictionary); 
			}
			var asFacDuration:Number = Timer.timeAction(asfacAction, NumberOfResolutions);
			
			var toleratedDuration:Number = manualDuration * AllowableTolerance;
			var whatWouldHaveBeenOk:Number = asFacDuration / manualDuration;
			assertTrue(asFacDuration < toleratedDuration);
		}
	}
}