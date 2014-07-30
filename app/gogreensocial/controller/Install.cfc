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
	* @cfcommons:rest:uri /install
	* @cfcommons:rest:httpMethod GET
	*/		
	public any function initialization(){		
		return true;
		
		/*
		var user = invoke.user();
		user.email("yakoob@gogreensocial.com");
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
		blog.subject('The Go<span style="font-weight:bolder;color:##33cc00;">Green</span>Social mission...');
		blog.metaData('to provide the world with software that will enable everyday people to make a real impact towards preserving our people and planet.');
		savecontent variable="body" {		
			include '/view/install/home_blog_body.cfm';
		};		
		blog.body(body);		
		blog.user(user);		
		blog.save();
		
		var u = invoke.user().findById(1);

		initiative = invoke.initiative();
		initiative.name("Gas To Gas: From Farm Waste To Renewable Energy");
		initiative.date(now());
		initiative.summary("EARTH University students & volunteers will build biodigesters in rural communities in Costa Rica to help farmers convert manure and other organic waste into methane gas that can be used for cooking.");
		initiative.issue("People living in rural, developing areas are often forced to use practices that are both damaging to the environment & community health. Trees must be cut down to provide fuel to cook food. Contaminated manure is used to fertilize plants, contributing to outbreaks of E. coli & other illnesses. EARTH's Community Development Program helps install biodigesters that aid rural farmers in converting manure into pathogen-free organic fertilizer & bio-gas that can be used for cooking and heating.");
		initiative.solution("Students & professors work with farmers to install biodigesters, which decontaminate waste water and provide ample methane gas for cooking. Families save money by having a free supply of fuel & organic fertilizer to use on crops, lessening illness.");
		initiative.message("The impact of a biodigester goes well beyond aiding the environment, it can help alleviate poverty in many areas of the world");		
		initiative.status("active");
		initiative.user(u);
		initiative.save();		
		writedump(initiative);

		initiative = invoke.initiative();
		initiative.name("500 solar lamps to 500 families in Malava, Kenya");
		initiative.date(now());
		initiative.summary("Youth from Malava will locally make solar lamps using scrap metals, and Poor families in Malava will get the lamps and save part of the money initially spent on kerosene and set up small businesses");
		initiative.issue("In Kenya, there are over 27 Million people with no electricity. According to 2009 Kenya government census, over 40,000 people in Malava have no electricity and rely on kerosene lanterns and firewood for lighting and cooking. The project will provide 500 locally made solar lamps to 500 families, each with an average of 7 people. The families will use part of the money initially spent on kerosene to set up small businesses after getting the lamps. Education, health and environment will improve");
		initiative.solution("Youth will be trained to make solar lamps. The lamps shall be distributed to poor families through groups. The families will be trained on micro-enterprise, and helped to set up small businesses from the money initially spent on kerosene");
		initiative.message("We have been able to set up this bee-keeping business after we received the solar lamps from SDFA. We don't beg our husbands for money anymore since we sell the honey..our families are so happy");		
		initiative.status("active");
		initiative.user(u);
		initiative.save();		
		writedump(initiative);
		
		initiative = invoke.initiative();
		initiative.name("Preserving El Farallon Natl. Monument, Costa Rica");
		initiative.date(now());
		initiative.summary("Preserving this 48 ha. tropical, dry forest will save it from being sold for development and maintain the forest habitat that the resident wildlife depend on in this privately owned natl. monument.");
		initiative.issue("The Lopez’s have owned El Farallon for generations. It was declared a natl. monument for the ancient petroglyphs on the cliff walls. They have always conserved the forest. They receive no payment as guardians of the monument, the CO2 sequestered or the needed habitat. Off the grid w/solar power, they have no “footprint”. Even so, for 6 people living in the old wooden house a small income from cattle isn’t enough. These forests are for sale to be developed. It is all regenerated tropical forest");
		initiative.solution("Payments for environmental services to the Lopez’s for the habitat provided to the diverse wildlife and CO2 sequestration saves the forests from being sold and developed. Guaranteeing a home for all the life and helping to clean the air of our Earth");
		initiative.message("We need to eat. FONAFIFO had us on contract to regenerate forest for 5 years and afterward, now, they say they cannot pay us anymore. We can't do anything now but conserve it without income.");		
		initiative.status("active");
		initiative.user(u);
		initiative.save();	
		writedump(initiative);
	
		initiative = invoke.initiative();
		initiative.name("Protest California Drilling");
		initiative.date(now());
		initiative.summary("We are also taking steps to make our office buildings and other facilities efficient. That means pursuing LEED certification for our offices, retrofitting our buildings to bring in more natural light, using high-efficiency lighting, and installing better building control systems. We perform extensive energy audits to understand and further reduce our electricity use. We’ve spent millions of dollars on these efforts because they save energy and pay back in only a few years.</p><p>Every day, our cafeterias strive to source locally-grown food, compost organic waste, and recycle. Thousands of Googlers commute to our headquarters on biodiesel shuttles, use our fleet of hybrid vehicles for off campus meetings, and use Google bikes to get around campus. Googlers can even rack up points for a donation to their favorite charity by walking, biking, gliding, pogo-sticking, unicycling, or otherwise finding a self-powered way to get to work.");
		initiative.status("active");
		initiative.user(u);
		initiative.save();		
		writedump(initiative);
		
		initiative = invoke.initiative();
		initiative.name("Trees In Brazil");
		initiative.date(now());
		initiative.summary("The scientists from Norway, Brazil and the UK said that very little was know about the fate of Brazil nuts under natural condition, despite it being one of the most economically important non-timber crops to come out of Amazonia.");
		initiative.status("active");
		initiative.user(u);			
		initiative.save();	
		writedump(initiative);
		
		var asset = invoke.Material();
		asset.cost("125.50");
		asset.quantity(100);
		asset.name("Pine Tree");
		asset.isDonation(true);		
		initiative.ledger().addAssets(asset);

		var asset = invoke.Material();
		asset.cost("15.00");
		asset.quantity(25);
		asset.name("Shovels");
		asset.isDonation(true);		
		initiative.ledger().addAssets(asset);

		var asset = invoke.People();
		asset.cost("0");
		asset.quantity(25);
		asset.name("Planters");
		asset.isVolunteer(true);		
		initiative.ledger().addAssets(asset);
				
		var asset = invoke.Place();
		asset.cost("10,000");
		asset.quantity(1);
		asset.name("DLY 4552-Brazil");
		asset.isBooked(true);		
		initiative.ledger().addAssets(asset);
						
		
		var boon = invoke.LedgerBoon();
		boon.assetId(1);
		boon.quantity(10);		
		boon.personFk(1);
		initiative.ledger().addLedgerBoon(boon);

		var boon = invoke.LedgerBoon();
		boon.assetId(3);
		boon.quantity(1);
		boon.personFk(1);		
		initiative.ledger().addLedgerBoon(boon);			
	
		structdelete(session, "user");				
						
		writeoutput("application initialization complete. ..");
		abort;
		*/
		
	}	


	/**	
	* @cfcommons:rest:uri /test
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
