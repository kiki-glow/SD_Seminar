page 50102 "CSD Seminar List"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 5 - Lab 2-6
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar";
    Caption = 'Seminar List';
    Editable = false;
    CardPageId = 50101;
    
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    
                }

                field("Name"; Rec."Name")
                {

                }

                field("Seminar Duration"; Rec."Seminar Duration")
                {

                }

                field("Seminar Price"; Rec."Seminar Price")
                {

                }

                field("Minimum Participants"; Rec."Minimum Participants")
                {

                }

                field("Maximum Participants"; Rec."Maximum Participants")
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
            group("Seminar")
            {
                Caption = '&Seminar'; // means Alt + S can select/open the Seminar group.

                action("Comments")
                {
                    Caption = 'Co&mments'; // means Alt + M can select the Comments action.
                    //RunObject=page "CSD Seminar Comment Sheet";
                    //RunPageLink = "Table Name" = const(Seminar), "No." = field("No.");
                    Image = Comment;
                }
            }
        }

        area(Processing)
        {
            action(ActionName)
            {
                Caption = 'Action Name';

                trigger OnAction()
                begin
                    // add an action here
                end;
            }
        }
    }
}