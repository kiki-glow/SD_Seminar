enum 50102 "CSD Approval Status"
{
    Extensible = false;
    
    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Pending)
    {
        Caption = 'Pending Approval';
    }
    value(2; Approved)
    {
        Caption = 'Approved';
    }
    value(3; Rejected)
    {
        Caption = 'Rejected';
    }
}