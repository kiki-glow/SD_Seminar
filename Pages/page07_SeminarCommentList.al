page 50107 "CSD Seminar Comment List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Comment Line";
    Caption = 'CSD Seminar Comment Line';
    Editable = false;
    
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
    
}