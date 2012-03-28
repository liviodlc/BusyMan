package com.rivermanmedia {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		}


		private function drawTitle():void {
			title = new Sprite();

			// white bg
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			graphics.endFill();
			
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
			prototext.text = "Prototype #3.0 - March 27, 2012";
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
			featuretext.y = STAGE_HEIGHT / 2 + 50;
			featuretext.height = STAGE_HEIGHT - featuretext.y - 10;
			featuretext.htmlText = "<b>Features:</b>\nPlayer movements are much more discrete, precise, and efficient.\n\n<b>Controls:</b>\nArrow keys to move left/right.\nUp Arrow Key to shoot normally.\nDown Arrow Key for super shot.";
			featuretext.selectable = false;
			title.addChild(featuretext);

			addChild(title);
			stage.addEventListener(MouseEvent.CLICK, onTitleClick, true, 0, true);
		}
		
		private function onTitleClick(evt:MouseEvent):void{
			removeChild(title);
			stage.removeEventListener(MouseEvent.CLICK, onTitleClick);
			
			stage.addEventListener(Event.ENTER_FRAME, onGameLoop, false, 0, true);
			stage.focus = stage;
		}
		
		private function initGame():void{
			game = new GameBoard();
			addChildAt(game, 0);
			
			player = new Player(stage, game);
			addChildAt(player, 0);
		}
		
		private function onGameLoop(evt:Event):void{
			player.onGameLoop();
			game.onGameLoop();
		}
	}
}
