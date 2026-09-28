page 50112 "CSD Seminar Details FactBox"
{
    Caption = 'Seminar Details FactBox';
    PageType = CardPart;
    SourceTable = "CSD Seminar";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ApplicationArea = All;
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
