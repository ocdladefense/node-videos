/**
 * Taken from: https://sfdctrails.com/2022/06/08/parsing-csv-file-in-apex/
 */
public class CsvParser { // implements Iterator

    private List<String> lines;
    
    private List<String> headings;
    
    private List<List<String>> allFields;
    
    
    public CsvParser() {
       lines = new List<String>();
       headings = new List<String>();
       allFields = new List<List<String>>();
    }
    
    /**
     * How to remove BOM from an encoded base64 UTF string?
     * https://stackoverflow.com/questions/72222678/how-to-remove-bom-from-an-encoded-base64-utf-string
     */
    public CsvIterator parse(String base64) {
        return parseText(EncodingUtil.base64Decode(base64).toString());
    }
    
    
    public CsvIterator parseText(String csv) {


        csv = csv.replaceAll(',"""', ',"DBLQT').replaceAll('""",', 'DBLQT",');
        csv = csv.replaceAll('""', 'DBLQT');
        
        lines = csv.split('\n');

        // Assume that the first line is headings.
     	this.headings = (new CsvRow(lines.remove(0))).getFields();

		// Allows us to call parse() and iterator through all CSV lines.
		return new CsvIterator(lines, this.headings);
	}
    
    
    
    public static List<String> parseRow(String data) {
        List<String> fields = data.split(',');
        List<String> cleanFields = new List<String>();
        String compositeField;
        Boolean makeCompositeField = false;

        for (String field :fields) {
            field = field.trim();
            
            if (field.startsWith('"') && field.endsWith('"')) {
                cleanFields.add(field.replaceAll('DBLQT', '"'));
            } else if (field.startsWith('"')) {
                makeCompositeField = true;
                compositeField = field;
            } else if (field.endsWith('"')) {
                compositeField += ',' + field;
                cleanFields.add(compositeField.replaceAll('DBLQT', '"'));
                makeCompositeField = false;
            } else if (makeCompositeField) {
                compositeField += ',' + field;
            } else {
                cleanFields.add(field.replaceAll('DBLQT', '"'));
            }
        }
        
        return cleanFields;
    }
    


}