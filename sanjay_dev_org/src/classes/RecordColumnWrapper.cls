public class RecordColumnWrapper{
        @AuraEnabled
        public String apiName{get;set;}
        @AuraEnabled
        public String recordValue{get;set;}
        
        public RecordColumnWrapper(String apiName,String recordValue){
            this.apiName = apiName;
            this.recordValue = recordValue;
        }
    }