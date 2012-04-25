package com.rivermanmedia {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	public class GameBoard extends Sprite {

		[Embed(source = "levels/level1.txt", mimeType = "application/octet-stream")]
		private var Level1:Class;

		private var levelScript:String;
		private var t:Timer;
		private var s:TaskSpawner;
		private var a:Array;
		private var currentTask:Task = null;


		public function GameBoard() {
			var tmp:ByteArray = new Level1();
			levelScript = tmp.readMultiByte(tmp.bytesAvailable, tmp.endian);
			a = new Array();
		}


		public function startGame(stage:Stage):void {
			s = new TaskSpawner(this, "");
			addChild(s);

			stage.addEventListener(Event.ENTER_FRAME, onGameLoop, false, 0, true);
			stage.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}


		private function onGameLoop(evt:Event):void {
			s.onGameLoop();
			for each (var t:Task in a) {
				t.onGameLoop();
			}
		}


		private function onClick(evt:MouseEvent):void {
			if (currentTask)
				currentTask.isHighlighted = false;
			if (evt.target is Task){
				currentTask = (evt.target as Task);
				currentTask.isHighlighted = true;
			}
		}


		public function addTask(t:Task):void {
			a.push(t);
			t.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			addChild(t);
		}
	}
}
