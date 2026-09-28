page 50106 "CSD Seminar Comment Sheet"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Comment Line";
    Caption = 'CSD Seminar Comment Sheet';
    AutoSplitKey = true;
    
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Date; Rec.Date)
                {
                    
                }

                field(Code; Rec.Code)
                {
                    Visible = false;
                }

                field(Comment; Rec.Comment)
                {

                }
            }
        }
    }
    
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewLine();
    end;
}