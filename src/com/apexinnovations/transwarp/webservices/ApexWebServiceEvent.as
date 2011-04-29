/* ApexWebServiceEvent - defines the events that the ApexWebService class can dispatch
* 
* Copyright (c) 2011 Apex Innovations, LLC. All rights reserved. Any unauthorized reproduction, duplication or transmission by any means, is prohibited.
*/   
package com.apexinnovations.transwarp.webservices
{
	import flash.events.*;
	
	public class ApexWebServiceEvent extends Event {
		public static const BOOKMARK_COMPLETE:String = "ApexBookmarkServiceComplete";
		public static const BOOKMARK_FAILURE:String = "ApexBookmarkServiceFailure";
		public static const COMMENT_COMPLETE:String = "ApexCommentServiceComplete";
		public static const COMMENT_FAILURE:String = "ApexCommentServiceFailure";
		public static const LOG_COMPLETE:String = "ApexLogServiceComplete";
		public static const LOG_FAILURE:String = "ApexLogServiceFailure";
		public static const PAGE_COMPLETE:String = "ApexPageServiceComplete";
		public static const PAGE_FAILURE:String = "ApexPageServiceFailure";
		public static const SEARCH_COMPLETE:String = "ApexSearchServiceComplete";
		public static const SEARCH_FAILURE:String = "ApexSearchServiceFailure";
		public var command:String;
		public var data:*;
		
		public function ApexWebServiceEvent(command:String, data:Object = null) {
			super(command);
			this.command = command;
			this.data = data;
		}		
	}
	
}