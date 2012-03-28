package com.rivermanmedia {
	
	import flash.display.Sprite;

	public class GameBoard extends Sprite {
		
		public static const NUM_COLUMNS:uint = 12;
		public static const COL_WIDTH:uint = Main.STAGE_WIDTH / NUM_COLUMNS;
		
		public var columns:Array;
		
		public function GameBoard() {
			initColumns();
		}
		
		private function initColumns():void{
			columns = new Array(NUM_COLUMNS);
			
			graphics.lineStyle(1, 0x999999);
			for(var i:uint = 1; i <  NUM_COLUMNS; i++){
				var rightX:uint = i * COL_WIDTH;
				graphics.moveTo(rightX,0);
				graphics.lineTo(rightX,Main.STAGE_HEIGHT);
			}
		}
		
		public function onGameLoop():void{
			//game loop
		}
		
		public function getBlockAt(x:Number):Number{
			return -1;
		}
	}
}
