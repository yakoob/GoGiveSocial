/**
* @cfcommons:mvc:controller
* @extends shared.controller.Abstract
* @accessors true
*/
component {
	/**	
	* @ormtype integer
	* @fieldtype id	
	* @generated always	
	* @generator native	
	*/
	property id;
	
	public Install function init(){
		return super.init();
	}
	
	/**	
	* @cfcommons:rest:uri /install/setup
	* @cfcommons:rest:httpMethod GET
	*/		
	public any function initialization(){		
		
		var user = invoke.user();
		user.email("yakoob@cfsn.net");
		user.firstname("Yakoob");
		user.lastname("Ahmad");
		user.password("games01");
		user.verifyPassword("games01");
		user.createdate(dateformat(now(),"full"));
		user.save();
		
		session.user = user.save(); 		
		
		var blog = invoke.homeblog();
		blog.date(dateformat(now(), "full"));
		blog.status("active");
		blog.subject('So what is this all about?');
		blog.metaData('to provide the world with software that will enable everyday people to make a real impact towards preserving our people and planet.');
		savecontent variable="body" {		
			include '/view/install/home_blog_body.cfm';
		};		
		blog.body(body);		
		blog.user(user);		
		blog.save();
		
		var u = invoke.user().findById(1);
	
		initiative = invoke.initiative();
		initiative.name("Empower India's Trafficked Girls Through Education");
		initiative.date(now());
		initiative.summary("Kranti empowers trafficked girls and sex workers to become catalysts of social change and lead the women’s revolution in India! (It is the only organization created BY trafficked girls, not FOR them.)");
		initiative.issue("Kranti (Revolution) addresses the problem of trafficking of underaged women into Mumbai by providing these girls (Revolutionaries) with education, leadership training, career guidance, and the resources they need to achieve their life goals. Kranti's model will have a spiraling effect as the Revolutionaries become empowered enough to: sponsor and mentor younger trafficked women, be the voices of oppressed women across India, and prove that every woman is an intellectual asset, not a liability.");
		initiative.solution("If we provide formal education, leadership training and mentorship/career guidance, the Revolutionaries will build sustainable, independent futures-ensuring they are not vulnerable to being trafficked and can be agents of change in their communities.");
		initiative.message("With my 6 years of experience in brothels and NGOs, I know that *I* can change society’s attitudes and make them understand the value of women – I just need the tools to lead this revolution! ");		
		initiative.status("active");
		initiative.user(u);
		initiative.save();		
		writedump(initiative);
		
		initiative = invoke.initiative();
		initiative.name("Homes For 15 Families Living In Containers Armenia");
		initiative.date(now());
		initiative.summary("Assisting 15 poor families living in metal containers in Vanadzor city, Armenia to overcome poverty housing and build homes which they did not have since 1988 earthquake.");
		initiative.issue("The devastating earthquake of 1988 left many families homeless in north-west of Armenia including Vanadzor city. The collapse of former Soviet Union, economic hardship combined with the earthquake left many families in Vanadzor with no hope. More than 1,200 families live in metal containers in Vanadzor city “metal containers” district. More than one generation of kids grew up in these temporary shelters that have no bathroom, no kitchen, are freezing cold in winter and blistering hot in summer.");
		initiative.solution("Fuller Center for Housing in partnership with two other organizations is assisting these families to build homes by using the innovative Styrofoam technology. New homes will have heating, proper sanitation, electricity, kitchen, natural gas and oven.");
		initiative.message("For many years we have been dreaming about having our own nice and proper home and move out of the metal container, where we lived more than 20 years. More than one generation grew up in these homes - Aida Ghukasyan, beneficiary, mother of 3 kids");		
		initiative.status("active");
		initiative.user(u);
		initiative.save();		
		writedump(initiative);		

		initiative = invoke.initiative();
		initiative.name("Help A Landmine Victim Walk Again");
		initiative.date(now());
		initiative.summary("Landmines kill & maim innocent children and adults on a daily basis throughout the world. MLI helps landmine survivors by providing them with prosthetic limbs, medical care, and vocational training.");
		initiative.issue("For many war-torn countries, a primary obstacle in achieving sustainable progress is the deadly legacy of landmines, which inflict horrendous injuries on innocent civilians and make vast expanses of land unusable. In Afghanistan alone, 10 million landmines contaminate more than 65% of the land and kill 4 children under the age of 16 each day. Landmine survivors face life-long challenges and are often unable to find employment to support themselves or afford adequate medical care.");
		initiative.solution("MLI’s Survivors’ Assistance program combats the challenges faced by landmine survivors by providing prosthetic limbs, rehabilitative treatments and vocational training to victims to help them recover from their injuries and become self-sufficient.");
		initiative.message("I lost my leg in a landmine explosion in 2007 and lost all hope. But I’m so happy now—I love my new leg. I feel like a a whole person again. My life is new again because of MLI - Hasbullah, A 21-year old Afghan man");		
		initiative.status("active");
		initiative.user(u);
		initiative.save();		
		writedump(initiative);				
		
		initiative = invoke.initiative();
		initiative.name("Burmese Refugee Youth Prevent Addiction & Violence");
		initiative.date(now());
		initiative.summary("DARE Network's Teens for Kids Project will support Ultimate Frisbee, Art, and Music as an alternative to addiction & violence for girls and boys in 5 Refugee camps on the Thai/Burma border.");
		initiative.issue("For over 30 years the ethnic people of Burma have been fleeing systematic destruction of their homeland, security, livelihoods, culture and freedom by the Military Regime of Burma. Running from forced labor, rape, landmines and murder, 150,000 people have ended up in Refugee camps on the Thai/Burma Border. Here they are prevented from working or leaving the camps. Trauma and loss have led to depression, addiction and community violence. Children and young people have no future and no hope.");
		initiative.solution("DARE Network's Teens for Kids Project provides a voice to the youth of the refugee camps. Via training, sports, art & music refugee teens share knowledge and raise the self-esteem of themselves & children, influencing their families and communities.");
		initiative.message("As Camp leader, I see the situations are improved by the DARE. Now not so much people fighting in the camp. People also selling & using drugs are decrease. Violent and rape in our community are less. - Saw Samson, Camp Leader of Nu Poe Refugee Camp");		
		initiative.status("active");
		initiative.user(u);
		initiative.save();	
		writedump(initiative);
		
		var asset = invoke.Material();
		asset.cost("25");
		asset.quantity(20);
		asset.name("Frisbee");
		asset.isDonation(true);		
		initiative.ledger().addAssets(asset);

		var asset = invoke.Material();
		asset.cost("100");
		asset.quantity(30);
		asset.name("Food & Drinks for 30 days");
		asset.isDonation(true);		
		initiative.ledger().addAssets(asset);

		var asset = invoke.Material();
		asset.cost("3000");
		asset.quantity(1);
		asset.name("equipment and addiction prevention material");
		asset.isDonation(true);		
		initiative.ledger().addAssets(asset);

		var asset = invoke.People();
		asset.cost("0");
		asset.quantity(12);
		asset.name("Camp Leaders");
		asset.isVolunteer(true);		
		initiative.ledger().addAssets(asset);
				
		var asset = invoke.Place();
		asset.cost(0);
		asset.quantity(0);
		asset.name("Burma, Nu Poe Refugee Camp");
		asset.isBooked(true);		
		initiative.ledger().addAssets(asset);
						
		
		var boon = invoke.LedgerBoon();
		boon.assetId(1);
		boon.quantity(2);		
		boon.personFk(1);
		initiative.ledger().addLedgerBoon(boon);

		var boon = invoke.LedgerBoon();
		boon.assetId(4);
		boon.quantity(1);
		boon.personFk(1);		
		initiative.ledger().addLedgerBoon(boon);			
	
		structdelete(session, "user");				
						
		writeoutput("application initialization complete. ..");
		abort;
	}	


	/**	
	* @cfcommons:rest:uri /test/test
	* @cfcommons:rest:httpMethod GET
	*/		
	public any function test(){		
		var boon = invoke.ledgerBoon().findById(1);
		writedump(boon);
		writedump(boon.boon().totalCost());
		writedump(boon.person());				
		abort;
	}	
		
}
