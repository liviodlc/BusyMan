package com.rivermanmedia {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	
	[SWF(width = "500", height = "375", frameRate = "30", backgroundColor = "#000000")]

	public class BusyMan extends Sprite {
		
		private var player:Player;
		private var welcome:Sprite;
		
		public function BusyMan() {
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0,0,500,375);
			graphics.endFill();
			
			initGame();
			initWelcomeText();
			
			stage.addEventListener(Event.ENTER_FRAME, onGameLoop, false, 0, true);
		}
		
		private function initGame():void{
			player = new Player(stage);
			addChild(player);
		}
		
		private function initWelcomeText():void{
			welcome = new Sprite();
			
			addChild(welcome);
		}
		
		private function onGameLoop(evt:Event):void{
			player.onGameLoop();
		}
	}
}
