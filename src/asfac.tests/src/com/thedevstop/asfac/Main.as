package com.thedevstop.asfac
{
	import asunit.textui.TestRunner;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author David Ruttka
	 */
	public class Main extends Sprite
	{
		public function Main():void
		{
			var unittests:TestRunner = new TestRunner();
			stage.addChild(unittests);
			unittests.start(AllTests, null, TestRunner.SHOW_TRACE);
		}
	}

}