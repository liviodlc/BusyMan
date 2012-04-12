package com.rivermanmedia {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class Player extends Sprite {

		private static const PLAYER_WIDTH:uint = 25;
		private static const PLAYER_HEIGHT:uint = 40;

		private static const GLOW_COLOR:uint = 0xDDDDDD;
		private static const PATH_COLOR:uint = 0x0033FF; // blue
		private static const GRAPPLE_SUPER_COLOR:uint = 0x990000; // red

		private static const MOVE_DELAY:uint = 3;
		private static const MOVE_SPEED:Number = GameBoard.COL_WIDTH / MOVE_DELAY;

		private var isKey_Up:Boolean = false;
		private var isKey_Down:Boolean = false;
		private var isKey_Right:Boolean = false;
		private var isKey_Left:Boolean = false;
		private var isFiring:Boolean = false;
		private var fireDelay:Boolean = false;

		private var curPath:Sprite;

		private var curDelay:uint = 0;
		private var xSpeed:Number = 0;
		private var pathOffset:Number = 0;
		private var newX:Number;

		private var canvas:Sprite;
		private var glow:Sprite;
		private var game:GameBoard;
		private var paths:Array;

		private var curTask:Task;


		public function Player(theStage:Stage, game:GameBoard) {
			this.game = game;

			canvas = new Sprite();
			canvas.graphics.beginFill(0x009900); //green
			canvas.graphics.drawRect(0, 0, PLAYER_WIDTH, PLAYER_HEIGHT);
			canvas.graphics.endFill();
			addChild(canvas);

			x = newX = Main.STAGE_WIDTH / 2 + (GameBoard.COL_WIDTH - PLAYER_WIDTH) / 2;
			y = Main.STAGE_HEIGHT - PLAYER_HEIGHT;

			glow = new Sprite();
			glow.graphics.beginFill(GLOW_COLOR, 0.25); // light gray
			glow.graphics.drawRect(-(GameBoard.COL_WIDTH - PLAYER_WIDTH) / 2, -y, GameBoard.COL_WIDTH, Main.STAGE_HEIGHT);
			glow.graphics.endFill();
			addChildAt(glow, 0);

			paths = new Array(GameBoard.NUM_COLUMNS);
			for (var i:uint = 0; i < GameBoard.NUM_COLUMNS; i++) {
				var path:Sprite = new Sprite();
				path.graphics.beginFill(PATH_COLOR, 0.25);
				path.graphics.drawRect(0, -y, GameBoard.COL_WIDTH, Main.STAGE_HEIGHT);
				path.graphics.endFill();
				path.x = i * GameBoard.COL_WIDTH - x;
				path.alpha = 0;
				path.visible = false; //optimization
				addChildAt(path, 1);
				paths[i] = path;
			}


			theStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			theStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}


		private function onKeyDown(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 37: // Left Arrow Key
				case 65: // A
					isKey_Left = true;
					break;
				case 39: // Right Arrow Key
				case 68: // D
					isKey_Right = true;
					break;
				case 38: // Up Arrow Key
				case 87: // W
					isKey_Up = true;
					isFiring = false;
					break;
				case 40: // Down Arrow
				case 83: // S
					isKey_Down = true;
					break;
				case 32: // Spacebar
					game.addNewTask();
					break;
			}
		}


		private function onKeyUp(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 37: // Left Arrow Key
				case 65: // A
					isKey_Left = false;
					break;
				case 39: // Right Arrow Key
				case 68: // D
					isKey_Right = false;
					break;
				case 38: // Up Arrow Key
				case 87: // W
					isKey_Up = false;
					break;
				case 40: // Down Arrow
				case 83: // S
					isKey_Down = false;
					break;
			}
		}


		public function onGameLoop():void {
			updateControls();
			updateMovement();
			updatePaths();
		}


		private function updateControls():void {
			if (curDelay > 1) {
				curDelay--;
//				if (isKey_Up && !isFiring) {
//					fireDelay = true;
//				}
			} else {
				if (isKey_Up) {
					isFiring = true;
					newPath();
					xSpeed = 0;
				}
				if (isKey_Left && !isKey_Right) {
					xSpeed = -MOVE_SPEED;
					curDelay = MOVE_DELAY;
				} else if (!isKey_Left && isKey_Right) {
					xSpeed = MOVE_SPEED;
					curDelay = MOVE_DELAY;
				} else {
					xSpeed = 0;
				}
				//fireDelay = false;
				curPath = null;
			}
		}


		private function newPath():void {
			var i:uint = uint((x + PLAYER_WIDTH) / GameBoard.COL_WIDTH);
			var p:Sprite = paths[i];
			p.alpha = 1;
			p.visible = true;

			curTask = game.getTaskAt(i);
			if (curTask)
				curTask.isHighlighted = true;
		}


		private function updateMovement():void {
			newX += xSpeed;

			if (newX > Main.STAGE_WIDTH)
				newX = newX - Main.STAGE_WIDTH;
			else if (newX < 0)
				newX = Main.STAGE_WIDTH + newX;

			pathOffset = newX - x;

			x = newX;
		}


		private function updatePaths():void {
			var p:Sprite;
			for each (p in paths) {
				p.x -= pathOffset;
				if (p.alpha > 0.07) {
					p.alpha -= 0.07;
				} else {
					p.visible = false;
				}
			}
		}
	}
}
