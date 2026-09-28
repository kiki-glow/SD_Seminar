page 50110 "CSD Registration Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    DelayedInsert = true;
    AutoSplitKey = true;
    SourceTable = "CSD Seminar Registration Line";
    Caption = 'Lines';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Participant Contact No."; Rec."Participant Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Participant Name"; Rec."Participant Name")
                {
                    ApplicationArea = All;
                }
                field(Participated; Rec.Participated)
                {
                    ApplicationArea = All;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                }
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                    ApplicationArea = All;
                }
                field("To Invoice"; Rec."To Invoice")
                {
                    ApplicationArea = All;
                }
                field(Registered; Rec.Registered)
                {
                    ApplicationArea = All;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ToolTip = 'Specifies the value of the amount paid field.', Comment = '%';
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                }
            }
        }

    }


}