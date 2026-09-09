pageextension 50100 "CSD ResourceCardExt" extends "Resource Card"
// CSD1.00 - 2018-02-01 - D.E. Veloper
// Chapter 5 - Lab 1-2
// Added new fields:
// - Internal/External
// - Maximum Participants
// Added new FastTab
// Added code to OnOpenPage trigger

{
    layout
    {
        
        addlast(General)
        {
            // Explicit Rec. qualification required because NoImplicitWith is enabled
            field("CSD Resource Type"; Rec."CSD Resource Type")

            {

            }
            field("CSD Quantity Per Day"; Rec."CSD Quantity Per Day")
            {

            }
        }
        addafter("Personal Data")
        {
            group("CSD Room")
            {
                Caption = 'Room';
                Visible = ShowMaxField;
                field("CSD Maximum Participants"; Rec."CSD Maximum Participants")
                {

                }
            }
        }
    }

    trigger OnAfterGetRecord()

    begin
        ShowMaxField := (Rec.Type = Rec.Type::Machine);
        CurrPage.Update(false);
    end;

    var
        // [InDataSet] - *deprecated from runtime 11.0; no longer required as page variables are included automatically.*
        ShowMaxField: Boolean;
}