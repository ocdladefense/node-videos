// CsvLookupTest, CsvParserTest, CsvUploadTest
@isTest
public class CsvUploadTest {

          
    @testSetup
    private static void insertRecords() {

        Account a = new Account(Name='John Doe');
		insert a;

        
        Contact c = new Contact(AccountId=a.Id, FirstName='John', LastName='Doe', Email='test@example.com');
        insert c;

        Product2 prod = new Product2(Name='Milk',IsActive=True,QBCode__c='Test123ABC',ClickpdxCatalog__StandardPrice__c=100.00,ClickpdxCatalog__MemberPrice__c=80.00);
        insert prod;
    }
    
        
    @isTest
    private static void parseFromBase64LongCsvFile() {
        
        // This is Base 64 version of a much longer CSV File, entered directly as a string here.
        String data = 'Q29udGFjdCxQcm9kdWN0LE5vdGUgMSxOb3RlIDIsTm90ZSAzLFVuaXQgUHJpY2UsQW1vdW50LFBheW1lbnQsQmF0Y2ggdG90YWwsUmVjZWlwdCxBTVMNCkpvaG4gRG9lLFRlc3QxMjNBQkMsLCxhdCBzZW1pbmFyLCw1MDAuMDAsNTEwOCws4oCTLA0KSmVubmlmZXIgQmlybWluZ2hhbSwiUE1DMDMyNSwgc2Nob2wiLCwsYXQgc2VtaW5hciwiMjUsNSIsMjUuMDAsMTI0MzQsNTI1LjAwLOKAkyxYDQpBbHluZSBTYW5jaGV6LFBNQzAzMjUsLCxhdCBzZW1pbmFyLCwyMC4wMCxjLmMuLCwxMDA0MzgsWA0KUGF1bCBTdW1uZXIsU1hNMTgsLCxhdCBzZW1pbmFyLCwyMTUuMDAsYy5jLiwsNDM5LFgNCkxpc2EgUGFyZGluaSxTWE0xOCwsLGF0IHNlbWluYXIsLDIxNS4wMCxjLmMuLCw0NDAsWA0KQmlsbCBNZWx0b24sU1hNMTgsLCxhdCBzZW1pbmFyLCwyMTUuMDAsYy5jLiwsNDQxLFgNCkJlY2t5IERhdmlzLFNYMjUsLCxhdCBkb29yLCwzMDAuMDAsYy5jLiwsNDQyLFgNCkh1Z2ggRHV2YWxsLFBNQzAzMjUgKDIpLCwsYXQgc2VtaW5hciwyMCw0MCxjLmMuLCw0NDMsWA0KU2FsbGllIEVpbXN0YWQsU1gyNSwsLGF0IHNlbWluYXIsLDM1LjAwLGMuYy4sLDQ0NCxYDQpSb3NhbGluZCBMZWUsUE1DMDMyNSwsLGF0IHNlbWluYXIsLDIwLjAwLGMuYy4sLDQ0NSxYDQpXaWxsaWFtIFRob21zb24sIkdHMDMwMTI0LCBQTUMwMzI1IiwsLGF0IHNlbWluYXIsIjI1LDIwIiw0NS4wMCxjLmMuLCw0NDYsWA0KUm9iZXJ0IENhbGxhaGFuLCJTWE0xOCwgU1gyNSwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLCIyMTUsMzUsMjAiLDI3MCxjLmMuLCw0NDcsWA0KTWFyaXNhIEJveXNlbixTWE0xOCwsLGF0IHNlbWluYXIsLDIxNS4wMCxjLmMuLCw0NDgsWA0KRGF2aWQgSGF5ZXMsUE1DMDMyNSAoNiksLCxhdCBzZW1pbmFyLDIwLDEyMC4wMCxjLmMuLCw0NDksWA0KS3Jpc3RpbmEgS2F5bCxQTUMwMzI1LCwsYXQgc2VtaW5hciwsMjAuMDAsYy5jLiwsNDUwLFgNCk1hcmlzYSBCb3lzZW4sUE1DMDMyNSAoMiksLCxhdCBzZW1pbmFyLDIwLDQwLjAwLGMuYy4sLDQ1MSxYDQpSaWNoYXJkIEJhbHNsZXksUE1DMDMyNSxuZWVkIHRvIHNoaXAgOCwsYXQgc2VtaW5hciwyMCwyMDAuMDAsYy5jLiwsNDUyLFgNClBhdWwgU3VtbmVyLFBNQzAzMjUsLCxhdCBzZW1pbmFyLCwyMC4wMCxjLmMuLCw0NTMsWA0KUmViZWNjYSBHb3VnZSxUVEIyNSwsLGF0IHNlbWluYXIsLDU1LjAwLGMuYy4sLDQ1NSxYDQpMaW5kc2F5IEZvd2xlciwiUE1DMDMyNSwgUEwyNCIsLCxhdCBzZW1pbmFyLCIyMCwyMCIsNDAuMDAsYy5jLiwsNDU2LFgNCkVybmVzdCBaYWNoZXIsVFRCMjUsLCxhdCBzZW1pbmFyLCw1NS4wMCxjLmMuLCw0NTcsWA0KTWFnZ2llIFdhdWtseW4sU1gyNSwsLGF0IGRvb3IsLDIwNS4wMCxjLmMuLCw0NTgsWA0KS3lsaWUgUm9vdCwiUE1DMDMyNSwgRXhHMDYyMywgUkVQTzE3IiwsLGF0IHNlbWluYXIsIjIwLDIwLDIwIiw2MC4wMCxjLmMuLCw0NTksDQpTaGFubm9uIERvdWdsYXMsIlBNQzAzMjUsIEdHMDMwMTI0IiwsLGF0IHNlbWluYXIsIjIwLDIwIiw0MC4wMCxjLmMuLCw0NjAsDQpFdmUgQ29zdGVsbG8sIlBNQzAzMjUsIFBMMjQiLCwsYXQgc2VtaW5hciwiMjAsMjAiLDQwLjAwLGMuYy4sLDQ2MSwNClRhbWFyYSBTY3VsbCxQTUMwMzI1ICgxMCksbmVlZCB0byBzaGlwIDgsLGF0IHNlbWluYXIsMjAsMjAwLjAwLGMuYy4sLDQ2MiwNCkNhcm9sIE1jQ3VycnksIlBNQzAzMjUsIEV4RzA2MjMiLCwsYXQgc2VtaW5hciwiMjAsMjAiLDQwLjAwLGMuYy4sLDQ2MywNCkxhdXJhIEhhbnNvbixQTUMwMzI1LCwsYXQgc2VtaW5hciwsMjAuMDAsYy5jLiwsNDY0LA0KQWFyb24gQmVja2VyLCJFeEcwNjIzLCBQTUMwMzI1LCBQTDI0LCBSRVBPMTcsIEJHMDMxOCwgRGVNdW5pejIyIiwsLGF0IHNlbWluYXIsIjIwLDIwLDIwLDIwLDIwLDU1IiwxNTUuMDAsYy5jLiwsNDY1LA0KUm9uIEdyYXksUE1DMDMyNSwsLGF0IHNlbWluYXIsLDIwLjAwLGMuYy4sLDQ2NiwNCkJyYWRsZXkgVGlua2VyLEZTTTI0LG5lZWQgdG8gc2hpcCBuZXcgYm9vayBhZnRlciB3ZSByZWNlaXZlIHRoZW0sLGF0IHNlbWluYXIsLDM2NS4wMCxjLmMuLCw0NjcsDQpTa3llIEdyb3NzLFBNQzAzMjUgKDIpLCwsYXQgc2VtaW5hciwyMCw0MC4wMCxjLmMuLCw0NjgsDQpKb3NodWEgQ29sd2VsbCwiQkcwMzE4LCBQTUMwMzI1IiwsLGF0IHNlbWluYXIsIjIwLDIwIiw0MC4wMCxjLmMuLCw0NzAsDQpNYXJpc2EgQm95c2VuLERUTkIyMCwsLGF0IHNlbWluYXIsLDI0MC4wMCxjLmMuLCw0NzEsDQpCZXRoIEJlcm5pZXIsR0cwMzAxMjQgKDIpLCwsYXQgc2VtaW5hciwyNSw1MC4wMCxjLmMuLCw0NzIsDQpKZW5uaWZlciBSb2JpbnMsUE1DMDMyNSwsLGF0IHNlbWluYXIsLDIwLjAwLGMuYy4sLDQ3MywNClJlbmVlIFNlZGlsbG8sUE1DMDMyNSwsLGF0IHNlbWluYXIsLDIwLjAwLGMuYy4sLDQ3NCwNCk9sY290dCBUaG9tcHNvbixQTUMwMzI1LCwsYXQgc2VtaW5hciwsMjAuMDAsYy5jLiwzNzE1LjAwLDQ3NSwNCkFteSBZb3VuZyxQTUMwMzI1LCwsYXQgc2VtaW5hciwsMjAuMDAsY2FzaCws4oCTLA0KTGlzYSBQYXJkaW5pLFBNQzAzMjUsLCxhdCBzZW1pbmFyLCwyMC4wMCxjYXNoLDQwLjAwLOKAkywNCkFubmEgU2FtbW9ucyxUVEIyNSwsLGF0IHNlbWluYXIsLDU1LjAwLEludm9pY2UsLOKAkywNCkVsaXphYmV0aCBXYWtlZmllbGQsUE1DMDMyNSwsLGF0IHNlbWluYXIsLDIwLjAwLEludm9pY2UsNzUsLA0KQ29sZSBTYWhsZWVuLCJHRzAzMDEyNCAoMiksIFBMMjQgKDIpLCBQTUMwMzI1ICgyKSwgRXhHMDYyMyIsLCxhdCBzZW1pbmFyLCIyNSwyMCwyMCwyMCIsMTMwLjAwLGMuYy4sLDQ3NiwNCkxpemEgTGFuZ2ZvcmQsIlByaXNvbkcxOSwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLCIxMCwyMCIsMzAuMDAsYy5jLiwsNDc3LA0KU3V6YW5uZSBKb2huc29uLCJCRzAzMTgsIENPMTEsIEdHMDMwMTI0LCBQTUMwMzI1IiwsLGF0IHNlbWluYXIsIjIwLDIwLDI1LDIwIiw4NS4wMCxjLmMuLCw0NzgsDQpTdXphbm5lIEpvaG5zb24sUE1DMDMyNSwsLGF0IHNlbWluYXIsLDIwLjAwLGMuYy4sLDQ3OSwNCkxhd3JlbmNlIFRheWxvcixQTUMwMzI1LCwsYXQgc2VtaW5hciwsMjAuMDAsYy5jLiwsNDgwLA0KSmVubmlmZXIgTGFuZyBQZXJraW5zLCJHRzAzMDEyNCwgUE1DMDMyNSwgRXhHMDYyMyIsLCxhdCBzZW1pbmFyLCIyNSwyMCwyMCIsODAuMDAsYy5jLiwsNDgxLA0KU2hlbGJ5IFRob21hcywiR0cwMzAxMjQsIFBNQzAzMjUiLCwsYXQgc2VtaW5hciwiMjUsMjAiLDQ1LjAwLGMuYy4sLDQ4MiwNCkplc3NlIExvaHJrZSwiR0cwMzAxMjQsIFBNQzAzMjUiLCwsYXQgc2VtaW5hciwiMjUsMjAiLDQ1LjAwLGMuYy4sLDQ4MywNClRhbWFyYSBTY3VsbCxEZU11bml6MjIsLCxhdCBzZW1pbmFyLCw1NS4wMCxjLmMuLCw0ODQsDQpTaGVsbHkgS3JhZnQsIkJHMDMxOCwgUE1DMDMyNSwgU1gxOCIsLCxhdCBzZW1pbmFyLCIyMCwyMCwyMTUiLDI1NS4wMCxjLmMuLCw0ODUsDQpBbHlzc2EgQmFydGhvbG9tZXcsUE1DMDMyNSwsLGF0IHNlbWluYXIsLDIwLjAwLGMuYy4sLDQ4NiwNCkFtYW5kYSBHYXJ0eSwiQkcwMzE4LCBHRzAzMDEyNCwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLCIyMCwyNSwyMCIsNjUuMDAsYy5jLiwsNDg3LA0KUnlhbiBTY290dCwiRXhHMDYyMywgR0cwMzAxMjQsIFBNQzAzMjUiLCwsYXQgc2VtaW5hciwiMjAsMjUsMjAiLDY1LjAwLGMuYy4sLDQ4OCwNClJvYmVydCBDYWxsYWhhbixHRzAzMDEyNCwsLGF0IHNlbWluYXIsLDI1LjAwLGMuYy4sLDQ4OSwNCk1hZ2dpZSBXYXVrbHluLCJHRzAzMDEyNCwgUHJpc29uRzE5IiwsLGF0IHNlbWluYXIsIjI1LDEwIiwzNS4wMCxjLmMuLCw0OTAsDQpSYW5raW4gSm9obnNvbixHRzAzMDEyNCwsLGF0IHNlbWluYXIsLDI1LjAwLGMuYy4sLDQ5MSwNCktlbHNleSBKb25lcywiRXhHMDYyMywgR0cwMzAxMjQsIFJFUE8xNyIsLCxhdCBzZW1pbmFyLCIyMCwyNSwyMCIsNjUuMDAsYy5jLiwsNDkyLA0KS3Jpc3RlbmEgSGFuc2VuLCJHRzAzMDEyNCwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLCIyNSwyMCIsNDUuMDAsYy5jLiwsNDkzLA0KUGVyIE9sc29uLEV4RzA2MjMsLCxhdCBzZW1pbmFyLCwyMC4wMCxjLmMuLCw0OTQsDQpKZXJyZXR0IEdsYXNzLE5IVFNBRFdJMjMsLCxhdCBzZW1pbmFyLCwxMC4wMCxjLmMuLCw0OTUsDQpTYXJhIEZvcm9zaGFuaSxQTUMwMzI1LCwsYXQgc2VtaW5hciwsMjAuMDAsYy5jLiwxMTYwLjAwLDQ5Niw=';
        
        Test.startTest();
        
        CsvUpload controller = new CsvUpload();
        controller.createOrders = True;
        
        Test.setCurrentPage(Page.CsvUpload);
        
        controller.fileData = data;
        
        controller.removeFile();
        controller.doCancel();
        controller.doSubmit();
        
        
        /*
       	Pattern prodQty = Pattern.compile('((\\.+)\\s+\\((\\d+)\\))');
        
        String products = 'PMC (2), LMC (3)';
        for(String tmp : products.split(',')) {
            tmp = tmp.trim();
            
            Matcher m = prodQty.matcher(tmp);
            System.debug('Group count is: ' + m.groupCount());
            System.debug('Product Match is: ' + m.group(0));
            System.debug('Qty Match is: ' + m.group(1));
        }
*/
        
        Test.stopTest();
    }
}