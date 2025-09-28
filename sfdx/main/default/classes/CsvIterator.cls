public class CsvIterator implements Iterator<CsvRow> {

   private List<String> lines;
    
   private List<String> headings;
    
   private Integer currentIndex;
 

 
   public Boolean hasNext() { 
       return currentIndex < lines.size();
   }    
 
   public CsvRow next() {
       if(hasNext()) {
           return new CsvRow(lines[currentIndex++], this.headings);
       } else {
           throw new NoSuchElementException('Iterator has no more elements.');
       }
   } 

    
    public CsvIterator(List<String> lines, List<String> headings) {
        
       this.lines = lines;
       this.headings = headings;
       this.currentIndex = 0;
    }
}