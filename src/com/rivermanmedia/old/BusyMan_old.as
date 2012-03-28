package com.rivermanmedia.old {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	[SWF(width = "500", height = "375", frameRate = "30", backgroundColor = "#000000")]

	public class BusyMan_old extends Sprite {

		[Embed(source = "images/titlescreen_2.2.png")]
		private var TitleScreen:Class;

		private var title:Bitmap;
		private var healthBar:Sprite;

		private var tasks:Array;
		private var player:Player_old;


		public function BusyMan_old() {
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, 500, 375);
			graphics.endFill();
			graphics.lineStyle(1);
			graphics.moveTo(0, 330);
			graphics.lineTo(500, 330);

			healthBar = new Sprite();
			healthBar.x = 485;
			healthBar.y = 375;
			addChild(healthBar);

			initGame();

			title = new TitleScreen();
			addChild(title);
			stage.addEventListener(Event.ACTIVATE, onFocus, false, 0, true);
		}


		private function initGame():void {
			player = new Player_old(stage);
			addChild(player);
			tasks = [];
		}


		private function onFocus(evt:Event):void {
			removeChild(title);
			stage.addEventListener(Event.ENTER_FRAME, onGameLoop, false, 0, true);
			stage.addEventListener(Event.DEACTIVATE, onNoFocus, false, 0, true);
			stage.removeEventListener(Event.ACTIVATE, onFocus);
		}


		private function onNoFocus(evt:Event):void {
			title.alpha = .75;
			addChild(title);
			stage.addEventListener(Event.ACTIVATE, onFocus, false, 0, true);
			stage.removeEventListener(Event.ENTER_FRAME, onGameLoop);
			stage.removeEventListener(Event.DEACTIVATE, onNoFocus);
		}


		private function onGameLoop(evt:Event):void {
			var p:Point;
			var coll:Boolean = false;
			player.onGameLoop();
			p = player.grapplePoint;
			for each (var t:Task_old in tasks) {
				if (t.isDue) {
					if (t.alpha <= 0.1) {
						removeChild(t);
						tasks.splice(tasks.indexOf(t), 1);
					} else {
						t.alpha -= 0.1;
						if (t.isWork)
							player.health -= 2;
					}
				} else if (t.finished) {
					removeChild(t);
					tasks.splice(tasks.indexOf(t), 1);
					if (!t.isWork){
						player.health += 10;
						player.power += 5;
					}else{
						player.power += 5;
					}
				} else {
					t.onGameLoop();
					if (p != null && !coll) {
						if (t.hitTestPoint(p.x, p.y, true)) {
							player.grab(t);
							coll = true;
							if (t.isWork) {
								player.power -= 10;
							}
						}
					}
				}
			}
			// erase forgotten grapple paths
			for (var i:uint = 0; i < numChildren; i++) {
				var o:DisplayObject = getChildAt(i);
				if (o != player && o != title && !(o is Task_old) && o != healthBar) {
					o.alpha -= 0.05;
					if (o.alpha <= 0) {
						removeChild(o);
						i--;
					}
				}
			}
			// draw health
			var healthHeight:Number = player.health / 100 * 40;
			var powerHeight:Number = player.power / 100 * 40;
			with (healthBar.graphics) {
				clear();
				lineStyle();
				beginFill(0xCC0000);
				drawRect(0, -healthHeight, 12, healthHeight);
				endFill();
				beginFill(0x00CC00);
				drawRect(-15, -powerHeight, 12, powerHeight);
				endFill();
			}
			// spawn new tasks
			if (spawnTimer == 0) {
				spawnTimer = Math.random() * MAX_SPAWN_TIME + MAX_SPAWN_TIME;
				var newTask:Task_old = new Task_old((Math.random() >= 0.4));
				newTask.x = Math.random() * 500;
				newTask.y = -100;
				tasks.push(newTask);
				addChild(newTask);
			}
			spawnTimer--;
		}
		private static const MIN_SPAWN_TIME:uint = 10;
		private static const MAX_SPAWN_TIME:uint = 30 - MIN_SPAWN_TIME;
		private var spawnTimer:uint = 0;
	}
}
