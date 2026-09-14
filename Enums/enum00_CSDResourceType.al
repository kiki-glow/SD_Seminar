enum 50100 "CSD Resource Type"
{
    Extensible = true;
    
    value(0; Internal)
    {
        Caption = 'Internal';
    }

    value(1; External)
    {
        Caption = 'External';
    }
}

enum 50101 "CSD Seminar Resource Kind"
{
    Extensible = true;
    
    value(0; Instructor)
    {
        Caption = 'Instructor';
    }

    value(1; Room)
    {
        Caption = 'Room';
    }
}