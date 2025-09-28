// CsvLookupTest, CsvParserTest, CsvUploadTest
@isTest
public class CsvParserTest {
    
    
    private static String colData = 'Contact,Product,Total Amount';
    
    private static String rowData = 'John Doe,Ticket1,100.00';
    
    /**
* Setup a single CsvRow object.
* Ensure that we can access the fields by numeric index and by column name.
*/
    @isTest
    private static void testRow() {
        
        CsvRow row = new CsvRow(rowData,colData.split(','));  
        System.debug(row.getFieldMap());
        
        System.assert('John Doe' == row.get('Contact'));
        System.assert(row.get(0) == row.get('Contact'));
        
        // Also try fetching a column that doesn't exist.
        Boolean exceptionCaught = False;
        try {
            row.get('Foobar');
        } catch(CsvColumnNotFoundException e) {
            exceptionCaught = True;
        }
        
        System.assert(exceptionCaught);
    }
    
    
    
    
    
    
    
    /**
* Setup a simple CsvParser from the same data as above.
* Ensure that we can access the fields by numeric index and by column name.
*/
    @isTest
    private static void parseFromString() {
        
        
        List<String> together = new List<String>{colData,rowData};
            String joined = String.join(together,'\n');
        
        
        CsvParser parser = new CsvParser();
        CsvIterator it = parser.parse(EncodingUtil.base64Encode(Blob.valueOf(joined)));
          
        
        while(it.hasNext()) {
            CsvRow row = it.next();
            
            if(row.isBlank()) continue;
            
            System.debug(row.getFieldMap());
            
            String field = row.get(0);
            String c = row.get('Contact');
            System.debug('Contact (from field 0) is: '+field);
            System.debug('Contact (from map) is: '+c);
        }
    }
    
    
    
    
    @isTest
    private static void parseFromBase64() {
        
        // This is Base 64 version of the CSV File, entered directly as a string here.
        String data = 'Q29udGFjdCxQcm9kdWN0LFRvdGFsIEFtb3VudApKb2huIERvZSxUaWNrZXQxLDEwMC4wMA==';
        
        CsvParser parser = new CsvParser();
        CsvIterator it = parser.parse(data);
        
        
        while(it.hasNext()) {
            CsvRow row = it.next();
            
            if(row.isBlank()) continue;
            
            System.debug(row.getFieldMap());
            
            String field = row.get(0);
            String c = row.get('Contact');
            System.debug('Contact (from field 0) is: '+field);
            System.debug('Contact (from map) is: '+c);
            
        }
    }
    
    
    
    @isTest
    private static void parseFromBase64LongCsvFile() {
        
        // This is Base 64 version of a much longer CSV File, entered directly as a string here.
        String data = 'Q29udGFjdCxQcm9kdWN0LE5vdGUgMSxOb3RlIDIsTm90ZSAzLEFtb3VudCxQYXltZW50LEJhdGNoIHRvdGFsLFJlY2VpcHQsQU1TDQpKYW1lcyBHYXJkbmVyLHNjaG9sLCwsYXQgc2VtaW5hciw1MDAuMDAgLDUxMDgsLOKAkyxYDQpKZW5uaWZlciBCaXJtaW5naGFtLCJQTUMwMzI1LCBzY2hvbCIsLCxhdCBzZW1pbmFyLDI1LjAwICwxMjQzNCw1MjUuMDAgLOKAkyxYDQpBbHluZSBTYW5jaGV6LFBNQzAzMjUsLCxhdCBzZW1pbmFyLDIwLjAwICxjLmMuLCwxMDA0MzgsWA0KUGF1bCBTdW1uZXIsU1hNMTgsLCxhdCBzZW1pbmFyLDIxNS4wMCAsYy5jLiwsNDM5LFgNCkxpc2EgUGFyZGluaSxTWE0xOCwsLGF0IHNlbWluYXIsMjE1LjAwICxjLmMuLCw0NDAsWA0KQmlsbCBNZWx0b24sU1hNMTgsLCxhdCBzZW1pbmFyLDIxNS4wMCAsYy5jLiwsNDQxLFgNCkJlY2t5IERhdmlzLFNYMjUsLCxhdCBkb29yLDMwMC4wMCAsYy5jLiwsNDQyLFgNCkh1Z2ggRHV2YWxsLFBNQzAzMjUgKDIpLCwsYXQgc2VtaW5hciw0MC4wMCAsYy5jLiwsNDQzLFgNClNhbGxpZSBFaW1zdGFkLFNYMjUsLCxhdCBzZW1pbmFyLDM1LjAwICxjLmMuLCw0NDQsWA0KUm9zYWxpbmQgTGVlLFBNQzAzMjUsLCxhdCBzZW1pbmFyLDIwLjAwICxjLmMuLCw0NDUsWA0KV2lsbGlhbSBUaG9tc29uLCJHRzAzMDEyNCwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLDQ1LjAwICxjLmMuLCw0NDYsWA0KUm9iZXJ0IENhbGxhaGFuLCJTWE0xOCwgU1gyNSwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLDI3MC4wMCAsYy5jLiwsNDQ3LFgNCk1hcmlzYSBCb3lzZW4sU1hNMTgsLCxhdCBzZW1pbmFyLDIxNS4wMCAsYy5jLiwsNDQ4LFgNCkRhdmlkIEhheWVzLFBNQzAzMjUgKDYpLCwsYXQgc2VtaW5hciwxMjAuMDAgLGMuYy4sLDQ0OSxYDQpLcmlzdGluYSBLYXlsLFBNQzAzMjUsLCxhdCBzZW1pbmFyLDIwLjAwICxjLmMuLCw0NTAsWA0KTWFyaXNhIEJveXNlbixQTUMwMzI1ICgyKSwsLGF0IHNlbWluYXIsNDAuMDAgLGMuYy4sLDQ1MSxYDQpSaWNoYXJkIEJhbHNsZXksUE1DMDMyNSxuZWVkIHRvIHNoaXAgOCwsYXQgc2VtaW5hciwyMDAuMDAgLGMuYy4sLDQ1MixYDQpQYXVsIFN1bW5lcixQTUMwMzI1LCwsYXQgc2VtaW5hciwyMC4wMCAsYy5jLiwsNDUzLFgNClJlYmVjY2EgR291Z2UsVFRCMjUsLCxhdCBzZW1pbmFyLDU1LjAwICxjLmMuLCw0NTUsWA0KTGluZHNheSBGb3dsZXIsIlBNQzAzMjUsIFBMMjQiLCwsYXQgc2VtaW5hciw0MC4wMCAsYy5jLiwsNDU2LFgNCkVybmVzdCBaYWNoZXIsVFRCMjUsLCxhdCBzZW1pbmFyLDU1LjAwICxjLmMuLCw0NTcsWA0KTWFnZ2llIFdhdWtseW4sU1gyNSwsLGF0IGRvb3IsMjA1LjAwICxjLmMuLCw0NTgsWA0KS3lsaWUgUm9vdCwiUE1DMDMyNSwgRXhHMDYyMywgUkVQTzE3IiwsLGF0IHNlbWluYXIsNjAuMDAgLGMuYy4sLDQ1OSwNClNoYW5ub24gRG91Z2xhcywiUE1DMDMyNSwgR0cwMzAxMjQiLCwsYXQgc2VtaW5hciw0MC4wMCAsYy5jLiwsNDYwLA0KRXZlIENvc3RlbGxvLCJQTUMwMzI1LCBQTDI0IiwsLGF0IHNlbWluYXIsNDAuMDAgLGMuYy4sLDQ2MSwNClRhbWFyYSBTY3VsbCxQTUMwMzI1ICgxMCksbmVlZCB0byBzaGlwIDgsLGF0IHNlbWluYXIsMjAwLjAwICxjLmMuLCw0NjIsDQpDYXJvbCBNY0N1cnJ5LCJQTUMwMzI1LCBFeEcwNjIzIiwsLGF0IHNlbWluYXIsNDAuMDAgLGMuYy4sLDQ2MywNCkxhdXJhIEhhbnNvbixQTUMwMzI1LCwsYXQgc2VtaW5hciwyMC4wMCAsYy5jLiwsNDY0LA0KQWFyb24gQmVja2VyLCJFeEcwNjIzLCBQTUMwMzI1LCBQTDI0LCBSRVBPMTcsIEJHMDMxOCwgRGVNdW5pejIyIiwsLGF0IHNlbWluYXIsMTU1LjAwICxjLmMuLCw0NjUsDQpSb24gR3JheSxQTUMwMzI1LCwsYXQgc2VtaW5hciwyMC4wMCAsYy5jLiwsNDY2LA0KQnJhZGxleSBUaW5rZXIsRlNNMjQgLG5lZWQgdG8gc2hpcCBuZXcgYm9vayBhZnRlciB3ZSByZWNlaXZlIHRoZW0sLGF0IHNlbWluYXIsMzY1LjAwICxjLmMuLCw0NjcsDQpTa3llIEdyb3NzLFBNQzAzMjUgKDIpLCwsYXQgc2VtaW5hciw0MC4wMCAsYy5jLiwsNDY4LA0KSm9zaHVhIENvbHdlbGwsIkJHMDMxOCwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLDQwLjAwICxjLmMuLCw0NzAsDQpNYXJpc2EgQm95c2VuLERUTkIyMCwsLGF0IHNlbWluYXIsMjQwLjAwICxjLmMuLCw0NzEsDQpCZXRoIEJlcm5pZXIsR0cwMzAxMjQgKDIpLCwsYXQgc2VtaW5hciw1MC4wMCAsYy5jLiwsNDcyLA0KSmVubmlmZXIgUm9iaW5zLFBNQzAzMjUsLCxhdCBzZW1pbmFyLDIwLjAwICxjLmMuLCw0NzMsDQpSZW5lZSBTZWRpbGxvLFBNQzAzMjUsLCxhdCBzZW1pbmFyLDIwLjAwICxjLmMuLCw0NzQsDQpPbGNvdHQgVGhvbXBzb24sUE1DMDMyNSwsLGF0IHNlbWluYXIsMjAuMDAgLGMuYy4sMzcxNS4wMCAsNDc1LA0KQW15IFlvdW5nLFBNQzAzMjUsLCxhdCBzZW1pbmFyLDIwLjAwICxjYXNoLCzigJMsDQpMaXNhIFBhcmRpbmksUE1DMDMyNSwsLGF0IHNlbWluYXIsMjAuMDAgLGNhc2gsNDAuMDAgLOKAkywNCkFubmEgU2FtbW9ucyxUVEIyNSwsLGF0IHNlbWluYXIsNTUuMDAgLEludm9pY2UsLOKAkywNCkVsaXphYmV0aCBXYWtlZmllbGQsUE1DMDMyNSwsLGF0IHNlbWluYXIsMjAuMDAgLEludm9pY2UsNzUsLA0KQ29sZSBTYWhsZWVuLCJHRzAzMDEyNCAoMiksIFBMMjQgKDIpLCBQTUMwMzI1ICgyKSwgRXhHMDYyMyIsLCxhdCBzZW1pbmFyLDEzMC4wMCAsYy5jLiwsNDc2LA0KTGl6YSBMYW5nZm9yZCwiUHJpc29uRzE5LCBQTUMwMzI1IiwsLGF0IHNlbWluYXIsMzAuMDAgLGMuYy4sLDQ3NywNClN1emFubmUgSm9obnNvbiwiQkcwMzE4LCBDTzExLCBHRzAzMDEyNCwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLDg1LjAwICxjLmMuLCw0NzgsDQpTdXphbm5lIEpvaG5zb24sUE1DMDMyNSwsLGF0IHNlbWluYXIsMjAuMDAgLGMuYy4sLDQ3OSwNCkxhd3JlbmNlIFRheWxvcixQTUMwMzI1LCwsYXQgc2VtaW5hciwyMC4wMCAsYy5jLiwsNDgwLA0KSmVubmlmZXIgTGFuZyBQZXJraW5zLCJHRzAzMDEyNCwgUE1DMDMyNSwgRXhHMDYyMyIsLCxhdCBzZW1pbmFyLDgwLjAwICxjLmMuLCw0ODEsDQpTaGVsYnkgVGhvbWFzLCJHRzAzMDEyNCwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLDQ1LjAwICxjLmMuLCw0ODIsDQpKZXNzZSBMb2hya2UsIkdHMDMwMTI0LCBQTUMwMzI1IiwsLGF0IHNlbWluYXIsNDUuMDAgLGMuYy4sLDQ4MywNClRhbWFyYSBTY3VsbCxEZU11bml6MjIsLCxhdCBzZW1pbmFyLDU1LjAwICxjLmMuLCw0ODQsDQpTaGVsbHkgS3JhZnQsIkJHMDMxOCwgUE1DMDMyNSwgU1gxOCIsLCxhdCBzZW1pbmFyLDI1NS4wMCAsYy5jLiwsNDg1LA0KQWx5c3NhIEJhcnRob2xvbWV3LFBNQzAzMjUsLCxhdCBzZW1pbmFyLDIwLjAwICxjLmMuLCw0ODYsDQpBbWFuZGEgR2FydHksIkJHMDMxOCwgR0cwMzAxMjQsIFBNQzAzMjUiLCwsYXQgc2VtaW5hciw2NS4wMCAsYy5jLiwsNDg3LA0KUnlhbiBTY290dCwiRXhHMDYyMywgR0cwMzAxMjQsIFBNQzAzMjUiLCwsYXQgc2VtaW5hciw2NS4wMCAsYy5jLiwsNDg4LA0KUm9iZXJ0IENhbGxhaGFuLEdHMDMwMTI0LCwsYXQgc2VtaW5hciwyNS4wMCAsYy5jLiwsNDg5LA0KTWFnZ2llIFdhdWtseW4sIkdHMDMwMTI0LCBQcmlzb25HMTkiLCwsYXQgc2VtaW5hciwzNS4wMCAsYy5jLiwsNDkwLA0KUmFua2luIEpvaG5zb24sR0cwMzAxMjQsLCxhdCBzZW1pbmFyLDI1LjAwICxjLmMuLCw0OTEsDQpLZWxzZXkgSm9uZXMsIkV4RzA2MjMsIEdHMDMwMTI0LCBSRVBPMTciLCwsYXQgc2VtaW5hciw2NS4wMCAsYy5jLiwsNDkyLA0KS3Jpc3RlbmEgSGFuc2VuLCJHRzAzMDEyNCwgUE1DMDMyNSIsLCxhdCBzZW1pbmFyLDQ1LjAwICxjLmMuLCw0OTMsDQpQZXIgT2xzb24sRXhHMDYyMywsLGF0IHNlbWluYXIsMjAuMDAgLGMuYy4sLDQ5NCwNCkplcnJldHQgR2xhc3MsTkhUU0FEV0kyMywsLGF0IHNlbWluYXIsMTAuMDAgLGMuYy4sLDQ5NSwNClNhcmEgRm9yb3NoYW5pLFBNQzAzMjUsLCxhdCBzZW1pbmFyLDIwLjAwICxjLmMuLDExNjAuMDAgLDQ5Niw=';
        
        CsvParser parser = new CsvParser();
        CsvIterator it = parser.parse(data);
        
        Integer index = 0;
        
        while(it.hasNext()) {
            System.debug('Evaluating index: '+ ++index);
            CsvRow row = it.next();
            
            // if(row.isBlank()) continue;
            
            System.debug(row.getFieldMap());
            
            String field = row.get(0);
            String c = row.get('Contact');
            System.debug('Contact (from field 0) is: '+field);
            System.debug('Contact (from map) is: '+c);
            
        }
    }
}