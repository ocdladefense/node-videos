public class ClickpdxShoppingCartInvalidFormException extends ClickpdxShoppingCartException {
        
        public String[] forms {get;private set;}
        
        public void addForm(String formName){
            this.addForms(new List<String>{formName});
        }
        
        public void addForms(List<String> formNames){
            if(null == forms){
                forms = new String[]{};
                    }
                forms.addAll(formNames);
        }
    }