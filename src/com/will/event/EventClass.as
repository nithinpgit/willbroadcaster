package com.will.event
{
	import com.will.engine.Engine;
	import com.will.model.Model;
	
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	public class EventClass
	{
		public function EventClass()
		{
			
		}
		private var mainapp:WillBroadcaster=FlexGlobals.topLevelApplication as WillBroadcaster;
		public static var instance:EventClass=null;
		public static function getInstance(): EventClass 	
		{
			if (instance == null )
				instance = new EventClass();
			return instance;
		}
		
		public function onConnectionStatus(status:String):void
		{
			//Alert.show(status);
			switch (status)
			{
				case "NetConnection.Connect.Success":
					if(Model.mode == '0'){
						Engine.getInstance().onPlay();
					}else{
						Engine.getInstance().publish();
					}
					
					break;
				
				case "NetConnection.Connect.Closed":
					setTimeout(Engine.getInstance().connect,2000);
					break;
				
				case "NetConnection.Connect.Failed":
					setTimeout(Engine.getInstance().connect,2000);
					break;
				case "NetConnection.Call.Failed":
					
					break;
				case "NetConnection.Connect.Rejected":
					
					
					break;
				
				
				
			}
			return;
		}
		public function controlVideo():void
		{
			if(Model.VIDEO_ENABLE)
			{
				Engine.getInstance().publishCam();
				
			}
			else
			{
				Engine.getInstance().unPublishCam();
				
				
			}
			
		}
		public function controlAudio():void
		{
			if(Model.AUDIO_ENABLE)
			{
				Engine.getInstance().publishMic();
			}
			else
			{
				Engine.getInstance().unPublishMic();
			}
		}
		public function onContinue():void{
			Engine.getInstance().connect();
			setTimeout(FlexGlobals.topLevelApplication.captureCurrentScreen,5000);
		}
				
	}
}


