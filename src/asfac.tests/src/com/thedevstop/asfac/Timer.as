package com.thedevstop.asfac 
{
	public class Timer 
	{
		private var _startTime:Number = NaN;
		private var _duration:Number = NaN;
		
		static public function timeAction(action:Function, timesToRun:int = 1):Number
		{
			var timer:Timer = new Timer();
			
			timer.start();
			
			for (var index:int = 0; index < timesToRun; index++)
				action();
			
			return timer.stop();
		}
		
		public function Timer() 
		{
			
		}
		
		/**
		 * Starts a new timer 
		 */
		public function start():void
		{
			_startTime = new Date().getTime();
		}
		
		/**
		 * Stops the timer
		 * @return the number of milliseconds since the timer was started
		 */
		public function stop():Number
		{
			return _duration = new Date().getTime() - _startTime;
		}
		
		/**
		 * The number of milliseconds the timer last ran
		 */
		public function get duration():Number
		{
			return _duration;
		}
	}
}