pageextension 50102 "CSD SourceCodeSetupExt" extends "Source Code Setup"
{
    layout
    { // this is where you can change what the user sees
        addafter("Cost Accounting")
        {
            group("CSD SeminarGroup")
            { // a box or section on the page to hold your fields
                Caption = 'Seminar';
                field(Seminar;"CSD Seminar")
                {
                    //
                }
            }
        }
    }
    
    actions
    { // buttons at the top of the page
        // Add changes to page actions here
    }
    
    var
        myInt: Integer;
}