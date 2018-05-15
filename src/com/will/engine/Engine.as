package com.will.engine
{
	
	import com.will.event.EventClass;
	import com.will.model.Model;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.core.FlexGlobals;
	
	public class Engine
	{
		public function Engine()
		{
		}
		public static var instance:Engine=null;
		public static function getInstance(): Engine 	
		{
			if (instance == null )
				instance = new Engine();
			return instance;
		}
		
		public function connect():void
		{
			if(Model.CONNECTED)
			{
				return;
			}
			if(Model._netconnection)
			{
				Model._netconnection.close();
				Model._netconnection=null;
			}
			Model._netconnection=new NetConnection();
			Model._netconnection.connect(Model.rtmp_url);
			Model._netconnection.addEventListener(NetStatusEvent.NET_STATUS,function onCon(event:NetStatusEvent):void{EventClass.getInstance().onConnectionStatus(event.info.code);});
			Model._netconnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,function onAsync(event:AsyncErrorEvent):void{});
		}
		public function publish():void
		{
			
			if(Model._publishStream!=null)
			{
				Model._publishStream.removeEventListener(NetStatusEvent.NET_STATUS,onPublishStreamStatus);
				Model._publishStream.close();
				Model._publishStream=null;
			}
			Model._publishStream = new NetStream(Model._netconnection);
			publishMic();
			publishCam();
			Model._publishStream.addEventListener(NetStatusEvent.NET_STATUS,onPublishStreamStatus);
			var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
			h264Settings.setProfileLevel(H264Profile.MAIN,H264Level.LEVEL_3_1);
			Model._publishStream.videoStreamSettings = h264Settings;
			Model._publishStream.publish(Model.publishName);
			Model._publishStream.bufferTime=0;
			
		}
		private function onPublishStreamStatus(event:NetStatusEvent):void
		{
			//Alert.show(event.info.code);
		}
		public function publishMic():void
		{
			if(Model._publishStream!=null)
			{
				Model._publishStream.attachAudio(accessMic());
			}
		}
		public function publishCam():void
		{
			if(Model._publishStream!=null)
			{
				if(Model.video==null)
				{
					Model.video=new Video(Model.VID_WIDTH,Model.VID_HIGHT);
					Model.video.smoothing=true;
				}
				Model.video.attachCamera(null);
				Model.video.attachCamera(accessCam());
				Model._publishStream.attachCamera(null);
				Model._publishStream.attachCamera(Model.cam);
				FlexGlobals.topLevelApplication.addVideo();
			}
			
		}
		public function unPublishCam():void
		{
			if(Model._publishStream!=null)
			{
				Model._publishStream.attachCamera(null);
				Model.video.attachCamera(null);
				Model.video=null;
				Model.cam=null;
			}
		}
		public function unPublishMic():void
		{
			if(Model._publishStream!=null)
			{
				Model._publishStream.attachAudio(null);
			}
		}
		public function accessCam():Camera
		{
			try
			{
				//Alert.show("access cam"+Model.CAMERA_INDEX.toString());
				Model.cam=null;
				Model.cam = Camera.getCamera(Model.CAMERA_INDEX.toString());
				Model.cam.setQuality(Model.BANDWIDTH,Model.QUALITY);
				Model.cam.setMode(Model.CAM_WIDTH,Model.CAM_HIGHT,Model.FPS,true);
				Model.cam.setKeyFrameInterval(30);
			}catch(e:Error)
			{
				
			}
			return Model.cam;
		}
		public function accessMic():Microphone
		{
			Model.mic=null;
			try{
				Model.mic =Microphone.getMicrophone(Model.MIC_INDEX);
				Model.mic.gain=60;
			}catch(e:Error)
			{
				
			}
			return Model.mic;
		}
		/**
		 *   For playing the stream
		 */
		public function onPlay():void
		{
			if(Model._netconnection==null)
			{
				return;
			}
			if(Model._playStream!=null)
			{
				Model._playStream.close();
				Model._playStream=null;
			}
			Model._playStream=new NetStream(Model._netconnection);
			Model._playStream.play(Model.publishName);
			Model.video=new Video(Model.VID_WIDTH,Model.VID_HIGHT);
			Model.video.attachNetStream(Model._playStream);
			Model.video.smoothing=true;
			FlexGlobals.topLevelApplication.addVideo();
			var soundTransform:SoundTransform= new SoundTransform(1);
			Model._playStream.soundTransform=soundTransform;
			Model._playStream.client=this;
			//adding event
			Model._playStream.addEventListener(NetStatusEvent.NET_STATUS,onStreamPlayStatus);
			Model._playStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError);
			Model._playStream.bufferTime=Model.BUFFER_TIME;
			return;
		}
		public function onAsyncError(event:AsyncErrorEvent):void
		{
			
		}
		/**
		 *Netstream Event 
		 * @param event
		 * 
		 */		
		public function onStreamPlayStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case "NetStream.Play.Start":
					
					break;
				case "NetStream.Play.Stop":
					
					break;
				case "NetStream.Play.UnpublishNotify":
					//	Alert.show("OnUnPublish");
					FlexGlobals.topLevelApplication.removeCam();
					break;
				case "NetStream.Video.DimensionChange":
					
					break;
				
			}
			event=null;
			return;
		}
	}
}



