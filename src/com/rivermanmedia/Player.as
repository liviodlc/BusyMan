package com.rivermanmedia {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;

	public class Player extends Sprite {

		private static const PLAYER_WIDTH:uint = 25;
		private static const PLAYER_HEIGHT:uint = 40;
		private static const GRAPPLE_COLOR:uint = 0x000099;
		private static const GRAPPLE_SUPER_COLOR:uint = 0x990000;

		private static const GRAVITY:uint = 3;
		private static const SUPER_GRAVITY:uint = 6;
		private static const JUMP_SPEED:int = -20;
		private static const RUN_ACC:uint = 7;
		private static const BRAKES:uint = 7;
		private static const MAX_SPEED:uint = 20;

		private static const GRAPPLE_SPEED:uint = 20;
		private static const GRAPPLE_SUPER_SPEED:uint = 20;

		private var isKey_Right:Boolean = false;
		private var isKey_Left:Boolean = false;
		private var isKey_Up:Boolean = false;
		private var isKey_Space:Boolean = false;
		private var isSuperSpace:Boolean = false;
		private var grappleEnded:Boolean = false;
		private var focusedOn:Task = null;

		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;

		private var newX:Number;
		private var newY:Number;
		private var floor:Number;
		private var isOnFloor:Boolean = false;
		
		public var health:Number = 100;
		public var power:Number = 100;

		private var grapple:Sprite;
		private var grapplePath:Sprite; // current grapple path/streak


		public function Player(stage:Stage) {
			// init keyboard controls
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);

			// starting position = bottom center of screen
			x = newX = 500 / 2;
			y = newY = floor = 375 - PLAYER_HEIGHT;

			// init grapple
			grapple = new Sprite();
			with (grapple.graphics) {
				lineStyle(1);
				beginFill(GRAPPLE_COLOR);
				moveTo(0, 0);
				lineTo(PLAYER_WIDTH / 2, 20);
				lineTo(0, 10);
				lineTo(-PLAYER_WIDTH / 2, 20);
				lineTo(0, 0);
				endFill();
			}
			grapple.x = PLAYER_WIDTH / 2;
			grapple.y = 0;
			grapple.visible = false;
			addChild(grapple);
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
					if (isOnFloor && !isKey_Up && !isKey_Space)
						ySpeed = JUMP_SPEED;
					isKey_Up = true;
					break;
				case 32: // Spacebar
					isKey_Space = true;
					if (!isOnFloor)
						isSuperSpace = true;
					if (!grappleEnded && !grapple.visible) {
						grapple.visible = true;
						grapplePath = new Sprite();
						with (grapplePath.graphics) {
							lineStyle();
							if (isSuperSpace)
								beginFill(GRAPPLE_SUPER_COLOR);
							else
								beginFill(GRAPPLE_COLOR);
							drawRect(0, 0, PLAYER_WIDTH / 2, 1);
							endFill();
						}
						grapplePath.x = PLAYER_WIDTH / 4;
						grapplePath.y = 10;
						addChildAt(grapplePath, 0);
					}
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
				case 32: // Spacebar
					isKey_Space = false;
					isSuperSpace = false;
					endGrapple();
					grappleEnded = false;
					break;
			}
		}


		private function endGrapple():void {
			grappleEnded = true;
			focusedOn=null;
			if (grapple.visible) {
				grapple.visible = false;
				grapple.y = 0;
				grapplePath.x = x + PLAYER_WIDTH / 4;
				grapplePath.y += y;
				parent.addChildAt(grapplePath, 0);
			}
		}


		public function get grapplePoint():Point {
			if (focusedOn==null && grapple.visible)
				return new Point(grapple.x + this.x, grapple.y + this.y);
			else
				return null;
		}


		public function onGameLoop():void {
			updateMovement();
			updateGrapple();
			updateVisuals();

			x = newX;
			y = newY;
		}


		private function updateMovement():void {
			var hasMoved:Boolean = false;
			isOnFloor = false;
			
			// move right
			if (isKey_Right && (!isKey_Space || focusedOn != null)) {
				xSpeed += RUN_ACC;
				if (xSpeed > MAX_SPEED)
					xSpeed = MAX_SPEED;
				hasMoved = true;
			}

			// move left
			if (isKey_Left && (!isKey_Space || focusedOn != null)) {
				xSpeed -= RUN_ACC;
				if (xSpeed < -MAX_SPEED)
					xSpeed = -MAX_SPEED;
				hasMoved = true;
			}

			// when not moving, slow down
			if (!hasMoved) {
				if (xSpeed > 0) {
					xSpeed -= BRAKES;
					if (xSpeed < 0)
						xSpeed = 0;
				} else if (xSpeed < 0) {
					xSpeed += BRAKES;
					if (xSpeed > 0)
						xSpeed = 0;
				}
			}

			if (isSuperSpace && !grappleEnded)
				ySpeed += SUPER_GRAVITY;
			else
				ySpeed += GRAVITY;

			newX += xSpeed;
			newY += ySpeed;

			if (newY > floor) {
				ySpeed = 0;
				newY = floor;
				isOnFloor = true;
			}

			var right:Number = 500 - PLAYER_WIDTH;
			if (newX > right) {
				newX = right;
			} else if (newX < 0) {
				newX = 0;
			}
			
			if(focusedOn!=null){
				focusedOn.x += newX - x;
				focusedOn.y += newY - y;
			}
		}


		private function updateGrapple():void {
			if (focusedOn==null && grapple.visible) {
				var theSpeed:uint;
				if (isSuperSpace)
					theSpeed = GRAPPLE_SUPER_SPEED;
				else
					theSpeed = GRAPPLE_SPEED;
				grapple.y -= theSpeed;
				grapplePath.y -= theSpeed;
				grapplePath.height += theSpeed;
				if (grapple.y < -300) {
					endGrapple();
				}
			}
			if(focusedOn!=null && !focusedOn.finished){
				focusedOn.focus(isSuperSpace, new Point(grapple.x + this.x - focusedOn.x, grapple.y + this.y - focusedOn.y));
				if(isSuperSpace)
					health--;
			}
		}


		private function updateVisuals():void {
			graphics.clear();
			/*if (isSuperSpace)
				graphics.beginFill(0xCC0000); //red
			else */
			if (isKey_Space)
				graphics.beginFill(0xFF6600); //orange
			else
				graphics.beginFill(0x009900); //green
			graphics.drawRect(0, 0, PLAYER_WIDTH, PLAYER_HEIGHT);
			graphics.endFill();
		}


		public function grab(t:Task):void {
			focusedOn = t;
		}
	}
}
