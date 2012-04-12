package com.rivermanmedia {
	import flash.display.Sprite;

	public class Task extends Sprite {

		private static const WORK_COLOR:uint = 0xCC0000;
		private static const PLAY_COLOR:uint = 0x00CC00;
		private static const BG_COLOR:uint = 0xFFFFFF;

		private static const OFFSET:uint = 2;
		private static const LEFT_BLOCK:uint = OFFSET * 3 / 2;

		private static const BLOCK_SIZE:uint = GameBoard.COL_WIDTH / 3 - OFFSET;

		private static const RUMBLE_MAX:Number = 5;
		private static const HIGHLIGHT_DELAY:uint = 5;
		private static const MAX_RANDOM_SIZE:uint = 12;
		private static const MAX_RANDOM_SPEED:Number = 0.5;


		public static function getRandomSize():uint {
			return uint(Math.floor(Math.random() * MAX_RANDOM_SIZE) + 1);
		}


		public static function getRandomSpeed():Number {
			return Math.random() * MAX_RANDOM_SPEED + 0.1;
		}

		private var isWork:Boolean;
		private var speed:Number
		private var blocks:Array;
		private var size:uint;

		public var isHighlighted:Boolean = false;
		private var workDelay:uint;
		private var nx:Number = -100;
		private var ny:Number;
		private var dx:Number = 0;
		private var dy:Number = 0;


		public function Task(size:uint, speed:Number, isWork:Boolean = true) {
			var color:uint;
			if (isWork)
				color = WORK_COLOR + getRandomColorOffset();
			else
				color = PLAY_COLOR;

			this.isWork = isWork;
			this.speed = speed;

			var mywidth:uint;
			this.size = size = size * 3;
			if (size >= 12) {
				mywidth = 2;
				if (size % 6 != 0)
					this.size = size = size + 3;
			} else {
				mywidth = 1;
			}
			blocks = new Array(size);
			var bx:Number = 0;
			var by:Number = -BLOCK_SIZE;
			var j:uint = 0;
			for (var i:uint = 0; i < size; i++) {
				var bl:Sprite = new Sprite();
				with (bl.graphics) {
					lineStyle();
					beginFill(color);
					drawRect(0, 0, BLOCK_SIZE, BLOCK_SIZE);
					endFill();
				}
				//TODO make this code general enough to work with width
				//add a variable to keep track of width
				if (j >= (3 * mywidth)) {
					by -= BLOCK_SIZE;
					j = 0;
				}
				bx = (LEFT_BLOCK * mywidth) + (BLOCK_SIZE * j);
				j++;
				/* else if (i % 3 == 1) {
					bx = LEFT_BLOCK; //left
				} else {
					bx = LEFT_BLOCK + (BLOCK_SIZE << 1); //right
				}*/
				bl.x = bx;
				bl.y = by;
				addChild(bl);
				blocks[i] = bl;
			}
			graphics.beginFill(BG_COLOR);
			graphics.drawRect((LEFT_BLOCK * mywidth) / 2, -height - LEFT_BLOCK / 2, width + (LEFT_BLOCK * mywidth), height + LEFT_BLOCK);
			graphics.endFill();
		}


		private function getRandomColorOffset():Number {
			return ((Math.random() * 0x44) - 0x22) << 16;
		}


		public function onGameLoop():void {
			if (nx == -100) {
				nx = x;
				ny = y;
			}
			if (isHighlighted) {
				//rumble:
				if (dx < 0)
					dx += Math.random() * RUMBLE_MAX;
				else
					dx -= Math.random() * RUMBLE_MAX;
				if (dx > RUMBLE_MAX)
					dx = RUMBLE_MAX;
				else if (dx < -RUMBLE_MAX)
					dx = -RUMBLE_MAX;

				if (dy < 0)
					dy += Math.random() * RUMBLE_MAX;
				else
					dy -= Math.random() * RUMBLE_MAX;
				if (dy > RUMBLE_MAX)
					dy = RUMBLE_MAX;
				else if (dy < -RUMBLE_MAX)
					dy = -RUMBLE_MAX;

				//delay:
				if (workDelay == 0) {
					var b:Sprite = getRandomBlock();
					if (b) {
						b.visible = false;
						size--;
					}
					if (size == 0) {
						visible = false;
					}
					workDelay = HIGHLIGHT_DELAY;
				} else {
					workDelay--;
				}
			} else if (dx != 0 || dy != 0) {
				dx = 0;
				dy = 0;
			}

			if(y - height > 0)
				ny += speed;
			else
				ny += speed * 8;
			isHighlighted = false;

			x = nx + dx;
			y = ny + dy;
		}


		private function getRandomBlock():Sprite {
			if (blocks) {
				var i:uint = Math.floor(Math.random() * blocks.length);
				if ((blocks[i] as Sprite).visible)
					return blocks[i];
				for (var j:uint = (i + 1) % blocks.length; j != i; j = (j + 1) % blocks.length) {
					if ((blocks[j] as Sprite).visible)
						return blocks[j];
				}
				blocks = null;
				return null;
			}
			return null;
		}
	}
}
