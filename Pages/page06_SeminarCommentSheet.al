page 50106 "CSD Seminar Comment Sheet"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Comment Line";
    Caption = 'CSD Seminar Comment Sheet';
    
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Date; Date)
                {
                    
                }

                field(Code; Code)
                {
                    Visible = false;
                }

                field(Comment; Comment)
                {

                }
            }
        }
    }
    
}