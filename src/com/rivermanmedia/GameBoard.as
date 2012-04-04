package com.rivermanmedia {

	import flash.display.Sprite;
	
	import org.interguild.LinkedList;

	public class GameBoard extends Sprite {

		public static const NUM_COLUMNS:uint = 12;
		public static const COL_WIDTH:uint = Main.STAGE_WIDTH / NUM_COLUMNS;

		public var columns:Array;


		public function GameBoard() {
			initColumns();
		}


		private function initColumns():void {
			columns = new Array(NUM_COLUMNS);

			graphics.lineStyle(1, 0x999999);
			for (var i:uint = 1; i < NUM_COLUMNS; i++) {
				var rightX:uint = i * COL_WIDTH;
				graphics.moveTo(rightX, 0);
				graphics.lineTo(rightX, Main.STAGE_HEIGHT);
			}

			for (i = 0; i < NUM_COLUMNS; i++) {
				var list:LinkedList = new LinkedList();
				columns[i] = list;
			}
		}


		public function onGameLoop():void {
//			var rand:Number = Math.random();
//			if(rand > 0.98)
//				addNewTask();

			updateAllTasks();
		}


		public function addNewTask():void {
			var t:Task = new Task(Task.getRandomSize(), Task.getRandomSpeed());
			var i:uint = getRandomColumn();
			t.x = i * COL_WIDTH;
			(columns[i] as LinkedList).add(t);
			addChild(t);
		}


		private function getRandomColumn():uint {
			return uint(Math.floor(Math.random() * NUM_COLUMNS));
		}


		private function updateAllTasks():void {
			for each (var list:LinkedList in columns) {
				var toRemove:LinkedList = new LinkedList();
				
				list.beginIteration();
				while (list.hasNext()) {
					var t:Task = (list.next as Task);
					t.onGameLoop();
					if(!t.visible || t.y > Main.STAGE_HEIGHT){
						toRemove.add(t);
						removeChild(t);
					}
				}
				
				toRemove.beginIteration();
				while(toRemove.hasNext()){
					list.remove(toRemove.next);
				}
			}
		}


		public function getTaskAt(i:uint):Task {
			var list:LinkedList = (columns[i] as LinkedList);
			var t:Task = null;
			list.beginIteration();
			while (list.hasNext()) {
				var task:Task = list.next as Task;
				if (t == null || t.y < task.y)
					t = task;
			}
			return t;
		}
	}
}
