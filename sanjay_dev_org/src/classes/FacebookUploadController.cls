public with sharing class FacebookUploadController 
{
	public string accessToken{get;set;}
	public string host{get;set;}
	public FacebookUploadController()
	{
		accessToken = Apexpages.currentPage().getparameters().get('accToken');
		host = Apexpages.currentPage().getparameters().get('host');
	}
}