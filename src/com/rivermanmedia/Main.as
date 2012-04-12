package com.rivermanmedia {

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.TextAlign;

	[SWF(width = "540", height = "430", frameRate = "30", backgroundColor = "#000000")]

	public class Main extends Sprite {

		public static const STAGE_WIDTH:uint = 540;
		public static const STAGE_HEIGHT:uint = 430;

		private var title:Sprite;
		private var player:Player;
		private var game:GameBoard;


		public function Main() {
			drawTitle();
			initGame();
			initVideo();
		}

		//YouTube stuff:
		private var _loader:Loader;
		private var _player:Object;


		private function initVideo():void {
			Security.allowDomain("s.ytimg.com");
			Security.allowDomain("www.youtube.com");
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, _onLoaderInit, false, 0, true);
			_loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}


		private function _onLoaderInit(event:Event):void {
			_player = _loader.content;
			_player.addEventListener("onReady", _onPlayerReady, false, 0, true);
			addChildAt(DisplayObject(_player), 0);

			_loader.contentLoaderInfo.removeEventListener(Event.INIT, _onLoaderInit);
			_loader = null;
		}


		private function _onPlayerReady(event:Event):void {
			_player.removeEventListener("onReady", _onPlayerReady);
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.  
			_player.setSize(STAGE_WIDTH, STAGE_HEIGHT);
			_player.loadVideoById("6BH49F_VVfw");
			_player.mute();
			_player.setLoop(true);
		}


		private function drawTitle():void {
			// white bg
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xFFFFFF, 0.25);
			bg.graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			bg.graphics.endFill();
			//addChild(bg);
			
			title = new Sprite();

			// white bg for clicking purposes
			var canvas:Sprite = new Sprite();
			canvas.graphics.beginFill(0xFFFFFF);
			canvas.graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			canvas.graphics.endFill();
			title.addChild(canvas);

			// "Busy Man" text
			var titletext:TextField = new TextField();
			var titleform:TextFormat = new TextFormat("Verdana", "80");
			titleform.align = TextAlign.CENTER;
			titletext.defaultTextFormat = titleform;
			titletext.autoSize = TextFieldAutoSize.CENTER;
			titletext.x = STAGE_WIDTH / 2;
			titletext.y = 20;
			titletext.text = "BUSY MAN";
			titletext.selectable = false;
			title.addChild(titletext);

			// prototype version text
			var prototext:TextField = new TextField();
			var protoform:TextFormat = new TextFormat("Arial", "24");
			protoform.align = TextAlign.CENTER;
			prototext.defaultTextFormat = protoform;
			prototext.autoSize = TextFieldAutoSize.CENTER;
			prototext.x = STAGE_WIDTH / 2;
			prototext.y = 120;
			prototext.text = "Prototype #5.2 - April 12, 2012";
			prototext.selectable = false;
			title.addChild(prototext);

			// "click here to start" text
			var clicktext:TextField = new TextField();
			var clickform:TextFormat = new TextFormat("Verdana", "26");
			clickform.align = TextAlign.CENTER;
			clicktext.defaultTextFormat = clickform;
			clicktext.autoSize = TextFieldAutoSize.CENTER;
			clicktext.x = STAGE_WIDTH / 2;
			clicktext.y = STAGE_HEIGHT / 2 - 20;
			clicktext.text = "Click Anywhere to Begin";
			clicktext.selectable = false;
			title.addChild(clicktext);

			// features text
			var featuretext:TextField = new TextField();
			var featureform:TextFormat = new TextFormat("Arial", "18");
			featureform.align = TextAlign.LEFT;
			featuretext.defaultTextFormat = featureform;
			featuretext.wordWrap = true;
			featuretext.x = 10;
			featuretext.width = STAGE_WIDTH - 20;
			featuretext.y = STAGE_HEIGHT / 2 + 40;
			featuretext.height = STAGE_HEIGHT - featuretext.y + 100;
			featuretext.htmlText = "<b>Controls:</b>\nArrow keys to move left/right.\nUp Arrow Key to shoot normally.\nSpacebar to create a task.\n\n<b>Features:</b>\nSlower task speed, multi-columned tasks, YouTube video backgrounds, task entrance animation.";
			featuretext.selectable = false;
			title.addChild(featuretext);

			addChild(title);
			stage.addEventListener(MouseEvent.CLICK, onTitleClick);
		}


		private function onTitleClick(evt:MouseEvent):void {
			removeChild(title);
			stage.removeEventListener(MouseEvent.CLICK, onTitleClick);

			stage.addEventListener(Event.ENTER_FRAME, onGameLoop, false, 0, true);
			stage.focus = stage;
		}


		private function initGame():void {
			game = new GameBoard();
			addChildAt(game, 0);

			player = new Player(stage, game);
			addChildAt(player, 0);
		}


		private function onGameLoop(evt:Event):void {
			player.onGameLoop();
			game.onGameLoop();
		}
	}
}
