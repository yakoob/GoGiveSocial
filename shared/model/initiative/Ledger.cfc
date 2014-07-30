/**
* @implements shared.model.initiative.ILedger
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Ledger
*/
component {
	/* in kind for gifing */
	
	/**
	* @fieldtype id
	* @generator native
	* @column ledgerId
	*/
	property id;

	/**
	* @type string
	*/
	property status;
	
	/**
	* @type array
	* @fieldtype one-to-many
	* @cfc shared.model.initiative.LedgerBoon
	* @fkcolumn ledgerId	
	* @cascade all
	*/	
	property ledgerBoon;
		
	/**
	* @type array
	* @cfcommons:ioc:implementation shared.model.asset.Asset
	* @fieldtype one-to-many
	* @cfc shared.model.asset.Asset
	* @fkcolumn ledgerId
	* @cascade all
	*/	
	property assets;
		
	public Ledger function init(){
		this.setStatus("active");
		super.init();
		return this;
	}
	
	public any function getDonationTotalDallor(){		
		var x = 0;
		for (local.y in this.getAssets()){
			try {
				if ( y.isDonation()  ) {
					x = x + (y.getCost() * y.getQuantity());					
				}								
			}
			catch(any e){
				// nothing
			}										
			try {
				if ( y.isBooked() || !y.isBooked()  ) {
					x = x + (y.getCost() * y.getQuantity());					
				}								
			}
			catch(any e){
				// nothing
			}													
		}		
		return x;
	}

	public any function getDonationTotalDallorBoon(){		
		var x = 0;
		boon = this.getLedgerBoon();
				
		for (local.b in boon){			
			var asset = invoke.asset().findById(b.assetId());				
			try {
				if ( asset.isDonation() ) {
					x = x + (asset.getCost() * b.getQuantity());					
				}								
			}
			catch(any e){
				// nothing
			}										
			try {
				if ( asset.isBooked() ) {	
					if (val(asset.getCost()))				
						x = x + (asset.getCost());					
				}								
			}
			catch(any e){
				// nothing
			}													
					
		}
		return x;
	}	

	public any function getMaterialTotalDallor(){		
		var x = 0;
		for (local.y in this.getAssets()){
			try {
				if ( y.isDonation()  ) {
					x = x + (y.getCost() * y.getQuantity());					
				}								
			}
			catch(any e){
				// nothing
			}																							
		}		
		return x;
	}

	public any function getMaterialTotalDallorBoon(){		
		var x = 0;
		boon = this.getLedgerBoon();
				
		for (local.b in boon){			
			var asset = invoke.asset().findById(b.assetId());				
			try {
				if ( asset.isDonation() ) {
					x = x + (asset.getCost() * b.getQuantity());					
				}								
			}
			catch(any e){
				// nothing
			}				
		}
		return x;
	}	
	

	public any function getPlaceTotalDallor(){		
		var x = 0;
		for (local.y in this.getAssets()){												
			try {
				if ( y.isBooked() || !y.isBooked()  ) {
					if (val(asset.getCost()))	
					x = x + (y.getCost());					
				}								
			}
			catch(any e){
				// nothing
			}													
		}		
		return x;
	}

	public any function getPlaceTotalDallorBoon(){		
		var x = 0;
		boon = this.getLedgerBoon();
				
		for (local.b in boon){			
			var asset = invoke.asset().findById(b.assetId());											
			try {
				if ( asset.isBooked() ) {					
					if (val(asset.getCost()))	
						x = x + (asset.getCost());					
				}								
			}
			catch(any e){
				// nothing
			}													
					
		}
		return x;
	}	

	public any function getTotalVolunteer(){		
		var x = 0;
		for (local.y in this.getAssets()){
			try {
				if ( y.isVolunteer() ) {
					x = x + y.getQuantity();					
				}								
			}
			catch(any e){
				// nothing
			}										
		}		
		return x;
	}
	
	public any function getTotalVolunteerBoon(){		
		var x = 0;
		boon = this.getLedgerBoon();
		
		
		for (local.b in boon){	
			var asset = invoke.asset().findById(b.assetId());					
			try {
				if ( asset.isVolunteer() ) {
					x = x + b.getQuantity();												
				}								
			}
			catch(any e){
				// nothing
			}										
			
		}			
		return x;
	}	
	
	public any function getVolunteers(){		
		var res = [];
		boon = this.getLedgerBoon();
		
		
		for (local.b in boon){	
			try {
				if ( invoke.asset().findById(b.assetId()).isVolunteer() )		
					arrayappend(res, b.person());
			}
			catch(any e){
				// nothing 
			}
		}			
		return res;
	}		
	

}
	