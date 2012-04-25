package com.rivermanmedia {

	public class Player {

		private static var allowConstructor:Boolean = false;
		private static var instance:Player = null;


		public static function getInstance(hud:HUD = null):Player {
			if (instance == null) {
				allowConstructor = true;
				instance = new Player();
			}
			if (hud != null) {
				instance.hud = hud;
			}
			return instance;
		}

		private var _score:Number = 0;
		private var _rank:Number = 1;
		private var _power:Number = 100;
		private var _health:Number = 100;
		private var _currentTask:Task = null;

		private var hud:HUD = null;


		public function Player() {
			if (!allowConstructor) {
				throw new Error("Error: Player is a singleton class. Please use Player.getInstance() instead of the constructor.");
			}
		}


		public function set score(n:Number):void {
			_score = n;
			hud.setScore(n);
		}


		public function set rank(n:Number):void {
			_rank = n;
			hud.setRank(n);
		}


		public function set power(n:Number):void {
			_power = n;
			hud.setPower(n);
		}


		public function set health(n:Number):void {
			_health = n;
			hud.setHealth(n);
		}
	}
}
