page 50108 "CSD Seminar Charge"
{
    Caption = 'Seminar Charge';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD seminar Charge";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = All;
                }
                field("To Invoice"; Rec."To Invoice")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

}