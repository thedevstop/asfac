package com.thedevstop.asfac
{
	import asunit.textui.TestRunner;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author
	 */
	public class Main extends Sprite
	{
		public function Main():void
		{
			var testRunner:TestRunner = new TestRunner();
			stage.addChild(testRunner);
			testRunner.start(AllTests, null, TestRunner.SHOW_TRACE);
		}
	}
}