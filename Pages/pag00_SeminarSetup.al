page 50100 "CSD Seminar Setup"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter - Lab 2-3
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CSD Seminar Setup";
    Caption = 'Seminar Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    
    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                field("Seminar Nos."; Rec."Seminar Nos.")
                {
                    
                }

                field("Seminar Registration Nos."; Rec."Seminar Registration Nos.")
                {

                }

                field("Posted Seminar Reg. Nos."; Rec."Posted Seminar Reg. Nos.")
                {

                }
            }
        }
    }
    
    
    trigger OnOpenPage()
    
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}

// Rec is necessary because the project enables NoImplicitWith. this ensures the page opens the single blank-primary-key setup record, creating it on first use.