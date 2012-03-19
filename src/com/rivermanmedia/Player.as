package com.rivermanmedia {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class Player extends Sprite {
		
		private static const PLAYER_WIDTH:uint = 25;
		private static const PLAYER_HEIGHT:uint = 40;
		
		private static const GRAVITY:uint = 3;
		private static const JUMP_SPEED:int = -20;
		private static const RUN_ACC:uint = 5;
		private static const BRAKES:uint = 5;
		private static const MAX_SPEED:uint = 15;
		
		private var isKey_Right:Boolean = false;
		private var isKey_Left:Boolean = false;
		
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		
		private var newX:Number;
		private var newY:Number;
		private var floor:Number;
		private var isOnFloor:Boolean = false;

		public function Player(stage:Stage) {
			// init placeholder graphics
			graphics.beginFill(0xCC0000);
			graphics.drawRect(0, 0, PLAYER_WIDTH, PLAYER_HEIGHT);
			graphics.endFill();

			// init keyboard controls
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
			
			// starting position = bottom center of screen
			x = newX = 500 / 2;
			y = newY = floor = 375 - 10 - PLAYER_HEIGHT;
		}


		private function onKeyDown(evt:KeyboardEvent):void {
			switch(evt.keyCode){
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
					if(isOnFloor)
						ySpeed = JUMP_SPEED;
					break;
			}
		}


		private function onKeyUp(evt:KeyboardEvent):void {
			switch(evt.keyCode){
				case 37: // Left Arrow Key
				case 65: // A
					isKey_Left = false;
					break;
				case 39: // Right Arrow Key
				case 68: // D
					isKey_Right = false;
					break;
			}
		}
		
		public function onGameLoop():void{
			updateMovement();
			
			x = newX;
			y = newY;
		}
		
		private function updateMovement():void{
			isOnFloor = false;
			
			// move right
			if(isKey_Right){
				xSpeed += RUN_ACC;
				if(xSpeed > MAX_SPEED){
					xSpeed = MAX_SPEED;
				}
			}
			
			// move left
			if(isKey_Left){
				xSpeed -= RUN_ACC;
				if(xSpeed < -MAX_SPEED){
					xSpeed = -MAX_SPEED;
				}
			}
			
			// when not moving, slow down
			if(!isKey_Left && !isKey_Right){
				if(xSpeed > 0){
					xSpeed -= BRAKES;
					if(xSpeed < 0)
						xSpeed = 0;
				} else if(xSpeed < 0){
					xSpeed += BRAKES;
					if(xSpeed > 0)
						xSpeed = 0;
				}
			}

			ySpeed += GRAVITY;

			newX += xSpeed;
			newY += ySpeed;
			
			if(newY > floor){
				ySpeed = 0;
				newY = floor;
				isOnFloor = true;
			}
			
			// wrap around!
			if(newX > 500){
				newX = -PLAYER_WIDTH;
			} else if(newX < -PLAYER_WIDTH) {
				newX = 500;
			}
		}
	}
}
