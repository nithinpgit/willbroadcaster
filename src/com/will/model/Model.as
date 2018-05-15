package com.will.model
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.collections.ArrayCollection;
	public class Model
	{
		public function Model()
		{
		}
		public static var rtmp_url:String;
		public static var mode:String;
		public static var publishName:String;
		public static var userId:String;
		//boolians
		[Bindable]public static var CONNECTED:Boolean=false;
		[Bindable]public static var CON_CLOSE:Boolean=false;
		[Bindable]public static var VIDEO_ENABLE:Boolean=true;
		[Bindable]public static var AUDIO_ENABLE:Boolean=true;
		public static var MIC_INDEX:Number=0;
		public static var CAMERA_INDEX:Number=0;
		public static var cam:Camera=null;
		public static var mic:Microphone=null;
		public static var video:Video=null;
		public static var _netconnection:NetConnection=null;
		public static var _publishStream:NetStream=null;
		
		[Bindable]public static var BANDWIDTH:Number        = 30000;
		[Bindable]public static var QUALITY:Number          = 90;
		[Bindable]public static var FPS : Number            = 30;
		[Bindable]public static var KEY_FRAME : Number      = 60;
		[Bindable]public static var BUFFER_TIME : Number    = 5;
		
		[Bindable]public static var UPDATE_TIME : Number    = 20000;
		
		[Bindable]public static var CAM_WIDTH:Number=320;
		[Bindable]public static var CAM_HIGHT:Number=240;
		[Bindable]public static var VID_WIDTH:Number=320;
		[Bindable]public static var VID_HIGHT:Number=240;
		
		public static var _playStream:NetStream=null;
		public static var cameraArray:ArrayCollection=new ArrayCollection();
		public static var microPhoneArray:ArrayCollection=new ArrayCollection();
		[Bindable]public static var AUDIO_LEVEL:Number=0;
		
		[Bindable]public static var APP_BG_COLOR:uint=0xffffff;
		[Bindable]public static var APP_BORDER_COLOR:uint=0xaeaeae;
		[Bindable]public static var TOOL_BAR_BG_COLOR_A:uint=0xf3f3f3;
		[Bindable]public static var TOOL_BAR_BG_COLOR_B:uint=0xf3f3f3;
		
	}
}
	