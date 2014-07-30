/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	
	public function init(){
		super.init();
		return this;
	}	
	
	/**
	* @cfcommons:rest:uri /blog/index
	* @cfcommons:rest:httpMethod GET
	* @event:broadcaster blogAdded
	*/			
	public struct function index(){					
		var x = invoke.blogComment();		
		return x;											
	}

	/**	
	* @cfcommons:mvc:url /blog/new
	*/
	public function blogNew(string type="home", numeric initiativeId=0){		
		reply.blogType = arguments.type;
		reply.uuid = arguments.uuid;			
		reply.initiativeId = arguments.initiativeId;			
		view = "/view/blog/new.cfm";		
	}	

	/**	
	* @cfcommons:mvc:url /blog/search/{type}
	*/
	public function blogByTypeSearch(numeric initiativeId=0, numeric userId=1){		
		reply.blogType = arguments.type;		
		reply.displayContext = arguments.displaycontext;					
		if ( findnocase("initiative", arguments.type) ) {
			i = invoke.initiative().findById(arguments.initiativeId);				
			reply.blog = i.blogs();
			reply.initiativeId = i.id();		
		}				
		else if ( findnocase("user", arguments.type) ) {
			var blog = evaluate("invoke.#type#Blog()");		
			reply.blog = blog.where({size="100",userId=session.user.id()});
			reply.userId = arguments.userId;
		}
		else {			
			var blog = evaluate("invoke.#type#Blog()");		
			reply.blog = blog.search();
		}					
		view = "/view/blog/search.cfm";		
	}	

	/**	
	* @cfcommons:rest:uri /blog/save
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public function saveBlog(string blogType=""){		
		return saveProcessData(arguments);						
	}	
	
	/**	
	* @cfcommons:rest:uri /blog/comment/{blogId}
	* @cfcommons:rest:httpMethod GET,POST
	*/
	public function blogCommentById(){		
		reply.blogId = arguments.blogId;		
		reply.comments = invoke.blog().findById(arguments.blogId).comment();				
		savecontent variable="displaycontent" {				
			include "/view/blog/comment.cfm";				
		};
		return event(args=arguments, DISPLAYCONTEXT=DISPLAYCONTEXT, DISPLAYMETHOD=DISPLAYMETHOD, display=displaycontent, eventname="blogCommentDisplayed");		
	}
	
	/**	
	* @cfcommons:rest:uri /blog/comment/save
	* @cfcommons:rest:httpMethod GET,POST	
	*/
	public function saveComment(){		
		arguments["po:BlogComment[userID]"] = session.user.id();			
		return saveProcessData(arguments);	
	}	
}