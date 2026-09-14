page 50101 "CSD Seminar Card"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 5 - Lab 2-4 & Lab 2-5
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CSD Seminar";
    Caption = 'Seminar Card';   
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update(false);
                    end;
                }

                field("Name"; Rec."Name")
                {

                }

                field("Search Name"; Rec."Search Name")
                {

                }

                field("Seminar Duration"; Rec."Seminar Duration")
                {

                }

                field("Minimum Participants"; Rec."Minimum Participants")
                {

                }

                field("Maximum Participants"; Rec."Maximum Participants")
                {

                }

                field("Blocked"; Rec."Blocked")
                {

                }

                field("Last Date Modified"; Rec."Last Date Modified")
                {

                }
            }

            group(Invoicing)
            {
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {

                }

                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    
                }

                field("Seminar Price"; Rec."Seminar Price")
                {
                    
                }
            }
        }

        area(FactBoxes)
        {
            systempart("Links"; Links)
            {

            }

            systempart("Notes"; Notes)
            {

            }
        }
    }
    
    actions
    {
        area(Navigation)
        {
            group("&Seminar")
            {
                action("Co&mments")
                {
                    //RunObject=page "CSD Seminar Comment Sheet";
                    //RunPageLink = "Table Name"= const(Seminar), 
                    // "No."=field("No.");
                    Image = Comment;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    // The Ampersand (&) represents the shortcut key to be used with the action
                }
            }
        }
    }
    
}