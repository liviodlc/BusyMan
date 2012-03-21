package com.rivermanmedia {

	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class Task extends Sprite {

		private static const MIN_SIZE:uint = 10;
		private static const MAX_SIZE:uint = 60;
		private static const MIN_DUE:uint = 90;
		private static const MAX_DUE:uint = 210 - MIN_DUE;

		private static const WORK_FILL_COLOR:uint = 0x254eff;
		private static const PLAY_FILL_COLOR:uint = 0x00CC00;
		private static const WORK_BORDER_COLOR:uint = 0x0000FF;
		private static const PLAY_BORDER_COLOR:uint = 0x006600;

		private static const FOCUS_SPEED:uint = 1; // shrinking speed
		private static const FOCUS_SUPER_SPEED:uint = 2; // shrinking speed

		private var canvas:Sprite;
		private var size:uint;
		private var due:Number;

		public var finished:Boolean = false;
		public var isWork:Boolean;


		public function Task(work:Boolean, due:Number = 0, size:uint = 0) {
			isWork = work;
			if (size == 0)
				size = Math.random() * MAX_SIZE + MIN_SIZE;
			if (due == 0)
				due = Math.random() * MAX_DUE + MIN_DUE;
			this.size = size;
			this.due = due;
			var borderColor:uint, fillColor:uint;
			if (work) {
				borderColor = WORK_BORDER_COLOR;
				fillColor = WORK_FILL_COLOR;
			} else {
				borderColor = PLAY_BORDER_COLOR;
				fillColor = PLAY_FILL_COLOR;
			}
			canvas = new Sprite();
			with (canvas.graphics) {
				lineStyle(2, borderColor);
				beginFill(fillColor);
				drawCircle(0, 0, size);
				endFill();
			}
			addChild(canvas);
		}


		public function get damage():Number {
			return (size - MIN_SIZE) * ((MAX_SIZE - MIN_SIZE) / 25);
		}


		public function onGameLoop():void {
			if (due > 1) {
				due--;
				var distance:Number = 330 - (y + size);
				var speed:Number = distance / due;
				y += speed;
			}
		}


		public function get isDue():Boolean {
			return (due <= 1);
		}


		public function focus(isSuper:Boolean, point:Point):void {
			if (isSuper) {
				size -= FOCUS_SUPER_SPEED;
				scaleFromCenter(canvas, 0.90, 0.90, point);
			} else {
				size -= FOCUS_SPEED;
				scaleFromCenter(canvas, 0.95, 0.95, point);
			}
			if (size < MIN_SIZE || width < 20)
				finished = true;
		}


		/**
		 * Source: http://ryanbosinger.com/blog/2008/actionscript-30-scale-object-from-center-point/
		 */
		private function scaleFromCenter(ob:*, sx:Number, sy:Number, ptScalePoint:Point):void {
			var m:Matrix = ob.transform.matrix;
			m.tx -= ptScalePoint.x;
			m.ty -= ptScalePoint.y;
			m.scale(sx, sy);
			m.tx += ptScalePoint.x;
			m.ty += ptScalePoint.y;
			ob.transform.matrix = m;
		}
	}
}
