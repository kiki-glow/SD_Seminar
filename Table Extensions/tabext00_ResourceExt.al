tableextension 50100 "CSD ResourceExt" extends Resource
// CSD1.00 - 2018-01-01 - D.E. Veloper
{
    fields
    {
        
        modify("Profit %")
        {
            trigger OnAfterValidate()
            begin
               Rec.TestField("Unit Cost"); 
            end;
        }

        // modify(Type)
        // {
        //     OptionCaption='Instructor,Room';
        // } // deprecated

        field(50101; "CSD Resource Type"; Enum "CSD Resource Type")
        {
            Caption = 'Resource Type';
            // OptionMembers = "Internal","External";
            // OptionCaption = 'Internal,External'; // create an enum instead of an option
        }

        field(50102; "CSD Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }

        field(50103; "CSD Quantity Per Day"; Decimal)
        {
            Caption = 'Quantity Per Day';
        }

        field(50104; "CSD Seminar Resource Kind"; Enum "CSD Seminar Resource Kind")
        {
            Caption = 'Seminar Resource Kind';
        }
    }
}